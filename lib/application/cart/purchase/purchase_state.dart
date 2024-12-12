part of 'purchase_bloc.dart';

@freezed
class PurchaseState with _$PurchaseState {
  const factory PurchaseState.initial() = _Initial;

  const factory PurchaseState.actionInProgress() = _ActionInProgress;

  const factory PurchaseState.purchaseSuccess() = _PurchaseSuccess;

  const factory PurchaseState.purchaseFailure(Failure<dynamic> failure) = _PurchaseFailure;

}
