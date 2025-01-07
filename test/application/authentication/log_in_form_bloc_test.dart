import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/application/authentication/login_form/log_in_form_bloc.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/get_valid_user.dart';
import 'package:invitations_project/domain/authentication/repository/authentication_repository_interface.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../test_descriptions.dart';
import 'log_in_form_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepositoryInterface>()])
void main() {
  late MockAuthenticationRepositoryInterface mockRepository;
  late LogInFormBloc logInFormBloc;

  const email = 'test@email.com';
  const password = 'abcd*1234';
  final validUser = getValidUser();
  final failure = Failure.data(
    DataFailure.serverError(errorString: "error"),
  );

  setUp(
    () {
      mockRepository = MockAuthenticationRepositoryInterface();
      logInFormBloc = LogInFormBloc(mockRepository);
    },
  );

  group(
    TestDescription.groupOnSuccess,
    () {
      blocTest<LogInFormBloc, LogInFormState>(
        'emits a state with the changed email when EmailChanged is added',
        build: () => logInFormBloc,
        act: (bloc) => bloc.add(
          LogInFormEvent.emailChanged(email),
        ),
        expect: () => [
          LogInFormState.initial().copyWith(
            email: EmailAddress(email),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<LogInFormBloc, LogInFormState>(
        'emits state with the changed password when PasswordChanged is added',
        build: () => logInFormBloc,
        act: (bloc) => bloc.add(
          LogInFormEvent.passwordChanged(password),
        ),
        expect: () => [
          LogInFormState.initial().copyWith(
            password: Password(password),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<LogInFormBloc, LogInFormState>(
        'emits [state, state] (first state is submitting and the latter is the result) when Registered is added and repository returns Right',
        build: () {
          when(
            mockRepository.register(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenAnswer((_) async => right(unit));
          return logInFormBloc;
        },
        seed: () => LogInFormState.initial().copyWith(
          email: EmailAddress(email),
          password: Password(password),
        ),
        act: (bloc) {
          bloc.add(const LogInFormEvent.registered());
        },
        verify: (_) => mockRepository.register(
          email: EmailAddress(email),
          password: Password(password),
        ),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(right(unit)),
          ),
        ],
      );

      blocTest<LogInFormBloc, LogInFormState>(
        'emits [state, state] (first state is submitting and the latter is the result) when LoggedInApple is added and repository returns Right',
        build: () {
          when(mockRepository.logInGoogle()).thenAnswer(
            (_) async => right(some(validUser)),
          );
          return logInFormBloc;
        },
        act: (bloc) => bloc.add(const LogInFormEvent.loggedInGoogle()),
        verify: (_) => mockRepository.logInGoogle(),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            thirdPartyUserOption: none(),
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            thirdPartyUserOption: some(validUser),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<LogInFormBloc, LogInFormState>(
        'emits [state, state] (first state is submitting and the latter is the result) when LoggedInApple is added and repository returns Right',
        build: () {
          when(mockRepository.logInApple()).thenAnswer(
            (_) async => right(some(validUser)),
          );
          return logInFormBloc;
        },
        act: (bloc) => bloc.add(const LogInFormEvent.loggedInApple()),
        verify: (_) => mockRepository.logInApple(),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            thirdPartyUserOption: none(),
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            thirdPartyUserOption: some(validUser),
            failureOrSuccessOption: none(),
          ),
        ],
      );
    },
  );

  group(
    TestDescription.groupOnFailure,
    () {
      blocTest<LogInFormBloc, LogInFormState>(
        'emits [state, state] (first state is submitting and the latter is the failure) when Registered is added and repository returns Left',
        build: () {
          when(
            mockRepository.register(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenAnswer((_) async => left(failure));
          return logInFormBloc;
        },
        seed: () => LogInFormState.initial().copyWith(
          email: EmailAddress(email),
          password: Password(password),
        ),
        act: (bloc) => bloc.add(const LogInFormEvent.registered()),
        verify: (_) => mockRepository.register(
          email: EmailAddress(email),
          password: Password(password),
        ),
        expect: () {
          return [
            logInFormBloc.state.copyWith(
              isSubmitting: true,
              showErrorMessages: false,
              failureOrSuccessOption: none(),
            ),
            logInFormBloc.state.copyWith(
              isSubmitting: false,
              showErrorMessages: true,
              failureOrSuccessOption: some(
                left(failure),
              ),
            ),
          ];
        },
      );

      blocTest<LogInFormBloc, LogInFormState>(
        'emits [state, state] (first state is submitting and the latter is the failure) when LoggedInGoogle is added and repository returns Left',
        build: () {
          when(mockRepository.logInGoogle()).thenAnswer(
            (_) async => left(failure),
          );
          return logInFormBloc;
        },
        seed: () => LogInFormState.initial().copyWith(
          email: EmailAddress(email),
          password: Password(password),
        ),
        act: (bloc) => bloc.add(const LogInFormEvent.loggedInGoogle()),
        verify: (_) => mockRepository.logInGoogle(),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
      );

      blocTest<LogInFormBloc, LogInFormState>(
        'emits [state, state] (first state is submitting and the latter is the failure) when LoggedInApple is added and repository returns Left',
        build: () {
          when(mockRepository.logInApple()).thenAnswer(
            (_) async => left(failure),
          );
          return logInFormBloc;
        },
        seed: () => LogInFormState.initial().copyWith(
          email: EmailAddress(email),
          password: Password(password),
        ),
        act: (bloc) => bloc.add(const LogInFormEvent.loggedInApple()),
        verify: (_) => mockRepository.logInApple(),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
      );
    },
  );

  // TODO: Test google and apple
}
