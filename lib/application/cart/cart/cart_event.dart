part of 'cart_bloc.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.addedInvitation(Invitation invitation) = _AddedInvitation;
  const factory CartEvent.purchased() = _Purchased;
  const factory CartEvent.emptied() = _Emptied;
}
