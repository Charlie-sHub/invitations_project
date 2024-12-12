import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:invitations_project/application/authentication/authentication/authentication_bloc.dart';
import 'package:invitations_project/data/core/misc/get_valid_user.dart';
import 'package:invitations_project/domain/authentication/repository/authentication_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/user.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'authentication_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepositoryInterface>()])
void main() {
  late MockAuthenticationRepositoryInterface mockRepository;
  late AuthenticationBloc authenticationBloc;

  setUp(
    () {
      mockRepository = MockAuthenticationRepositoryInterface();
      authenticationBloc = AuthenticationBloc(mockRepository);
    },
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits [UnAuthenticated] when event AuthenticationCheckRequested is added and repository returns none',
    build: () {
      when(mockRepository.getLoggedInUser()).thenAnswer(
        (_) async => none<User>(),
      );
      return authenticationBloc;
    },
    act: (bloc) => bloc.add(
      const AuthenticationEvent.authenticationCheckRequested(),
    ),
    verify: (_) => mockRepository.getLoggedInUser(),
    expect: () => const [AuthenticationState.unAuthenticated()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits [Authenticated] when event AuthenticationCheckRequested is added and repository returns some',
    build: () {
      when(mockRepository.getLoggedInUser()).thenAnswer(
        (_) async => some<User>(getValidUser()),
      );
      return authenticationBloc;
    },
    act: (bloc) => bloc.add(
      const AuthenticationEvent.authenticationCheckRequested(),
    ),
    verify: (_) => mockRepository.getLoggedInUser(),
    expect: () => const [AuthenticationState.authenticated()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits [UnAuthenticated] when event LoggedOut is added',
    build: () {
      when(mockRepository.logOut()).thenAnswer(
        (_) => Future.value(),
      );
      return authenticationBloc;
    },
    act: (bloc) => bloc.add(
      const AuthenticationEvent.loggedOut(),
    ),
    verify: (_) => mockRepository.logOut(),
    expect: () => const [AuthenticationState.unAuthenticated()],
  );
}
