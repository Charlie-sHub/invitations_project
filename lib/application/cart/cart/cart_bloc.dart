import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/application/core/failures/application_failure.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/cart/repository/cart_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';

part 'cart_event.dart';

part 'cart_state.dart';

part 'cart_bloc.freezed.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepositoryInterface _repository;

  CartBloc(this._repository) : super(CartState.initial()) {
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
                  Failure.application(ApplicationFailure.emptyCart()),
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
}
