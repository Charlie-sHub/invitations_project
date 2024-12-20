import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:invitations_project/application/authentication/authentication/authentication_bloc.dart';
import 'package:invitations_project/data/core/misc/get_valid_user.dart';
import 'package:invitations_project/domain/authentication/repository/authentication_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/user.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../core/mocks/mock_storage.dart';
import 'authentication_bloc_test.mocks.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

@GenerateNiceMocks([
  MockSpec<AuthenticationRepositoryInterface>(),
  MockSpec<Logger>(),
])
void main() {
  late MockAuthenticationRepositoryInterface mockRepository;
  late MockLogger mockLogger;
  late AuthenticationBloc authenticationBloc;
  late Storage storage;

  setUp(
    () {
      storage = MockStorage();
      mocktail
          .when(
            () => storage.write(mocktail.any(), mocktail.any<dynamic>()),
          )
          .thenAnswer((_) async {});

      HydratedBloc.storage = storage;
      mockRepository = MockAuthenticationRepositoryInterface();
      mockLogger = MockLogger();
      authenticationBloc = AuthenticationBloc(
        mockRepository,
        mockLogger,
      );
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
