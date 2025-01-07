import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:invitations_project/application/cart/cart/cart_bloc.dart';
import 'package:invitations_project/application/core/failures/application_failure.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/domain/cart/repository/cart_repository_interface.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../core/mocks/mock_storage.dart';
import 'cart_bloc_test.mocks.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

@GenerateNiceMocks([
  MockSpec<CartRepositoryInterface>(),
  MockSpec<Logger>(),
])
void main() {
  late MockCartRepositoryInterface mockRepository;
  late MockLogger mockLogger;
  late CartBloc cartBloc;
  late Storage storage;

  final failure = Failure.data(
    DataFailure.serverError(errorString: "error"),
  );

  final invitation = getValidInvitation();

  setUp(
    () {
      storage = MockStorage();
      mocktail
          .when(
            () => storage.write(
              mocktail.any(),
              mocktail.any<dynamic>(),
            ),
          )
          .thenAnswer((_) async {});
      HydratedBloc.storage = storage;

      mockRepository = MockCartRepositoryInterface();
      mockLogger = MockLogger();
      cartBloc = CartBloc(
        mockRepository,
        mockLogger,
      );
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
    'emits [state] when Purchased is added but there is no Invitation',
    build: () => cartBloc,
    act: (bloc) => bloc.add(const CartEvent.purchased()),
    expect: () => [
      CartState.initial().copyWith(
        showErrorMessages: true,
        failureOrSuccessOption: some(
          left(Failure.application(ApplicationFailure.emptyCart())),
        ),
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [state, state] when Purchased is added and repository returns Right on purchase and save',
    build: () {
      when(mockRepository.saveInvitation(invitation)).thenAnswer(
        (_) async => right(unit),
      );
      when(mockRepository.purchase()).thenAnswer(
        (_) async => right(unit),
      );
      return cartBloc;
    },
    seed: () => CartState.initial().copyWith(
      invitationOption: some(invitation),
    ),
    act: (bloc) => bloc.add(const CartEvent.purchased()),
    verify: (_) => mockRepository.saveInvitation(invitation),
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
    'emits [state, state] when Purchased is added and repository returns Right on saveInvitation but Left on purchase',
    build: () {
      when(mockRepository.saveInvitation(invitation)).thenAnswer(
        (_) async => left(failure),
      );
      return cartBloc;
    },
    seed: () => CartState.initial().copyWith(
      invitationOption: some(invitation),
    ),
    act: (bloc) => bloc.add(const CartEvent.purchased()),
    verify: (_) => mockRepository.saveInvitation(invitation),
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
        failureOrSuccessOption: some(left(failure)),
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [state, state] when Purchased is added and repository returns Left on saveInvitation',
    build: () {
      when(mockRepository.saveInvitation(invitation)).thenAnswer(
        (_) async => left(failure),
      );
      return cartBloc;
    },
    seed: () => CartState.initial().copyWith(
      invitationOption: some(invitation),
    ),
    act: (bloc) => bloc.add(const CartEvent.purchased()),
    verify: (_) => mockRepository.saveInvitation(invitation),
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
        failureOrSuccessOption: some(left(failure)),
      ),
    ],
  );

  blocTest<CartBloc, CartState>(
    'emits [state, state] when Purchased is added and repository returns Right on saveInvitation but Left on purchase',
    build: () {
      when(mockRepository.saveInvitation(invitation)).thenAnswer(
        (_) async => right(unit),
      );
      when(mockRepository.purchase()).thenAnswer(
        (_) async => left(failure),
      );
      return cartBloc;
    },
    seed: () => CartState.initial().copyWith(
      invitationOption: some(invitation),
    ),
    act: (bloc) => bloc.add(const CartEvent.purchased()),
    verify: (_) => mockRepository.deleteInvitation(invitation.id),
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
        failureOrSuccessOption: some(left(failure)),
      ),
    ],
  );
}
