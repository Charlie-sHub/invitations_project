import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/application/cart/cart/cart_bloc.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/domain/cart/repository/cart_repository_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'cart_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CartRepositoryInterface>()])
void main() {
  late MockCartRepositoryInterface mockRepository;
  late CartBloc cartBloc;

  final failure = Failure.data(
    DataFailure.serverError(errorString: "error"),
  );

  final invitation = getValidInvitation();

  setUp(
    () {
      mockRepository = MockCartRepositoryInterface();
      cartBloc = CartBloc(mockRepository);
    },
  );

  blocTest<CartBloc, CartState>(
    'emits [state] with the given invitation when addedInvitation is added',
    build: () => cartBloc,
    act: (bloc) => bloc.add(CartEvent.addedInvitation(invitation)),
    expect: () => [
      CartState.initial().copyWith(
        invitationOption: some(invitation),
        failureOrSuccessOption: none(),
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [state] without any invitation when Emptied is added',
    build: () => cartBloc..add(CartEvent.addedInvitation(invitation)),
    act: (bloc) => bloc.add(CartEvent.emptied()),
    skip: 1,
    expect: () => [
      CartState.initial(),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [state, state] when Purchased is added and repository returns Right',
    build: () {
      when(mockRepository.purchase()).thenAnswer(
        (_) async => right(unit),
      );
      cartBloc.add(CartEvent.addedInvitation(invitation));
      return cartBloc;
    },
    act: (bloc) => bloc.add(const CartEvent.purchased()),
    verify: (_) => mockRepository.purchase(),
    skip: 1,
    expect: () => [
      CartState.initial().copyWith(
        invitationOption: some(invitation),
        isSubmitting: true,
        showErrorMessages: false,
        failureOrSuccessOption: none(),
      ),
      CartState.initial().copyWith(
        invitationOption: some(invitation),
        isSubmitting: false,
        showErrorMessages: true,
        failureOrSuccessOption: some(right(unit)),
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [state, state] when Purchased is added and repository returns Left',
    build: () {
      when(mockRepository.purchase()).thenAnswer(
        (_) async => left(failure),
      );
      cartBloc.add(CartEvent.addedInvitation(invitation));
      return cartBloc;
    },
    act: (bloc) => bloc.add(const CartEvent.purchased()),
    verify: (_) => mockRepository.purchase(),
    skip: 1,
    expect: () => [
      CartState.initial().copyWith(
        invitationOption: some(invitation),
        isSubmitting: true,
        showErrorMessages: false,
        failureOrSuccessOption: none(),
      ),
      CartState.initial().copyWith(
        invitationOption: some(invitation),
        isSubmitting: false,
        showErrorMessages: true,
        failureOrSuccessOption: some(
          left(failure),
        ),
      ),
    ],
  );
}
