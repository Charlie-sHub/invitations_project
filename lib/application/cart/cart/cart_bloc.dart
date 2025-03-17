import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/application/core/failures/application_failure.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/models/invitation_dto.dart';
import 'package:invitations_project/domain/cart/repository/cart_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:logger/logger.dart';

part 'cart_event.dart';

part 'cart_state.dart';

part 'cart_bloc.freezed.dart';

@injectable
class CartBloc extends HydratedBloc<CartEvent, CartState> {
  CartBloc(this._repository, this._logger) : super(CartState.initial()) {
    on<CartEvent>(
      (event, emit) => event.when(
        addedInvitation: (invitation) => emit(
          state.copyWith(invitationOption: some(invitation)),
        ),
        purchased: () async => state.invitationOption.fold(
          () => emit(
            state.copyWith(
              showErrorMessages: true,
              failureOrSuccessOption: some(
                left(
                  const Failure.application(ApplicationFailure.emptyCart()),
                ),
              ),
            ),
          ),
          (invitation) async {
            emit(
              state.copyWith(
                isSubmitting: true,
                failureOrSuccessOption: none(),
              ),
            );
            final saveEither = await _repository.saveInvitation(invitation);
            emit(
              await saveEither.fold(
                (failure) => state.copyWith(
                  isSubmitting: false,
                  showErrorMessages: true,
                  failureOrSuccessOption: some(left(failure)),
                ),
                (_) async {
                  final purchaseEither = await _repository.purchase();
                  return purchaseEither.fold(
                    (failure) async {
                      await _repository.deleteInvitation(invitation.id);
                      return state.copyWith(
                        isSubmitting: false,
                        showErrorMessages: true,
                        failureOrSuccessOption: some(left(failure)),
                      );
                    },
                    (_) => state.copyWith(
                      isSubmitting: false,
                      showErrorMessages: true,
                      failureOrSuccessOption: some(right(unit)),
                    ),
                  );
                },
              ),
            );
            return null;
          },
        ),
        emptied: () => emit(CartState.initial()),
      ),
    );
  }

  final CartRepositoryInterface _repository;
  final Logger _logger;

  @override
  CartState? fromJson(Map<String, dynamic> json) {
    try {
      final invitation = InvitationDto.fromJson(
        json['invitationOption'] as Map<String, dynamic>,
      );
      final invitationOption = json['invitationOption'] != null
          ? some(invitation.toDomain())
          : none<Invitation>();
      return CartState(
        invitationOption: invitationOption,
        showErrorMessages: json['showErrorMessages'] as bool,
        // Won't save if the state was submitting or if there was a failure
        isSubmitting: false,
        failureOrSuccessOption: none(),
      );
    } on Exception catch (error) {
      _logger.e('Could not restore CartState from JSON: $error');
      return CartState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(CartState state) => {
        'invitationOption': state.invitationOption.fold(
          () => null,
          (invitation) => InvitationDto.fromDomain(invitation).toJson(),
        ),
        'showErrorMessages': state.showErrorMessages,
        // Won't save if the state was submitting or if there was a failure
      };
}
