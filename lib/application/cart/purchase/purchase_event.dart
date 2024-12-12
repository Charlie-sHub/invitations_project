part of 'purchase_bloc.dart';

@freezed
class PurchaseEvent with _$PurchaseEvent {
  const factory PurchaseEvent.boughtInvitation() = _BoughtInvitation;
}
