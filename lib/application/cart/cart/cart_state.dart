part of 'cart_bloc.dart';

@freezed
class CartState with _$CartState {
  const factory CartState({
    required Option<Invitation> invitationOption,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _CartState;

  factory CartState.initial() => CartState(
        invitationOption: none(),
        showErrorMessages: false,
        isSubmitting: false,
        failureOrSuccessOption: none(),
      );
}
