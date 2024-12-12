import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/application/cart/purchase/purchase_bloc.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/domain/cart/repository/cart_repository_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'purchase_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CartRepositoryInterface>()])
void main() {
  late MockCartRepositoryInterface mockRepository;
  late PurchaseBloc purchaseBloc;

  final failure = Failure.data(
    DataFailure.serverError(errorString: "error"),
  );

  setUp(
    () {
      mockRepository = MockCartRepositoryInterface();
      purchaseBloc = PurchaseBloc(mockRepository);
    },
  );

  blocTest<PurchaseBloc, PurchaseState>(
    'emits [actionInProgress, purchaseSuccess] when BoughtInvitation is added and repository returns Right',
    build: () {
      when(mockRepository.purchase()).thenAnswer(
        (_) async => right(unit),
      );
      return purchaseBloc;
    },
    act: (bloc) => bloc.add(const PurchaseEvent.boughtInvitation()),
    verify: (_) => mockRepository.purchase(),
    expect: () => const [
      PurchaseState.actionInProgress(),
      PurchaseState.purchaseSuccess(),
    ],
  );

  blocTest<PurchaseBloc, PurchaseState>(
    'emits [actionInProgress, purchaseFailure] when BoughtInvitation is added and repository returns Left',
    build: () {
      when(mockRepository.purchase()).thenAnswer(
        (_) async => left(failure),
      );
      return purchaseBloc;
    },
    act: (bloc) => bloc.add(const PurchaseEvent.boughtInvitation()),
    verify: (_) => mockRepository.purchase(),
    expect: () => [
      const PurchaseState.actionInProgress(),
      PurchaseState.purchaseFailure(failure),
    ],
  );
}
