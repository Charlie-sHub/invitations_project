import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/cart/repository/cart_repository_interface.dart';

part 'purchase_event.dart';

part 'purchase_state.dart';

part 'purchase_bloc.freezed.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final CartRepositoryInterface _repository;

  PurchaseBloc(this._repository) : super(const PurchaseState.initial()) {
    on<PurchaseEvent>(
      (event, emit) => event.when(
        boughtInvitation: () async {
          emit(PurchaseState.actionInProgress());
          final failureOrUnit = await _repository.purchase();
          emit(
            failureOrUnit.fold(
              (failure) => PurchaseState.purchaseFailure(failure),
              (_) => PurchaseState.purchaseSuccess(),
            ),
          );
          return null;
        },
      ),
    );
  }
}
