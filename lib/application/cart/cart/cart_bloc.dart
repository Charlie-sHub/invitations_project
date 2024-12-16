import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
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
        purchased: () async {
          emit(state.copyWith(
            isSubmitting: true,
            failureOrSuccessOption: none(),
          ));
          final failureOrUnit = await _repository.purchase();
          emit(
            state.copyWith(
              isSubmitting: false,
              showErrorMessages: true,
              failureOrSuccessOption: some(
                failureOrUnit.fold(
                  (failure) => left(failure),
                  (_) => right(unit),
                ),
              ),
            ),
          );
          return null;
        },
        emptied: () => emit(CartState.initial()),
      ),
    );
  }
}
