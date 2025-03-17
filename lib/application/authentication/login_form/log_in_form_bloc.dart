import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/authentication/repository/authentication_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/user.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';

part 'log_in_form_event.dart';

part 'log_in_form_state.dart';

part 'log_in_form_bloc.freezed.dart';

@injectable
class LogInFormBloc extends Bloc<LogInFormEvent, LogInFormState> {

  LogInFormBloc(this._repository) : super(LogInFormState.initial()) {
    on<LogInFormEvent>(
      (event, emit) => event.map(
        emailChanged: (event) => emit(
          state.copyWith(
            email: EmailAddress(event.email),
            failureOrSuccessOption: none(),
          ),
        ),
        passwordChanged: (event) => emit(
          state.copyWith(
            password: Password(event.password),
            failureOrSuccessOption: none(),
          ),
        ),
        registered: (_) => _performActionOnRepository(
          forwardedCall: _repository.register,
          emitter: emit,
        ),
        loggedIn: (_) => _performActionOnRepository(
          forwardedCall: _repository.logIn,
          emitter: emit,
        ),
        loggedInGoogle: (_) => _performActionOnThirdPartyLogin(
          forwardedCall: _repository.logInGoogle,
          emitter: emit,
        ),
        loggedInApple: (_) => _performActionOnThirdPartyLogin(
          forwardedCall: _repository.logInApple,
          emitter: emit,
        ),
      ),
    );
  }
  final AuthenticationRepositoryInterface _repository;

  Future<void> _performActionOnRepository({
    required Future<Either<Failure, Unit>> Function({
      required EmailAddress email,
      required Password password,
    }) forwardedCall,
    required Emitter<LogInFormState> emitter,
  }) async {
    final isEmailValid = state.email.isValid();
    final isPasswordValid = state.password.isValid();

    Either<Failure, Unit>? failureOrSuccess;

    if (isEmailValid && isPasswordValid) {
      emitter(
        state.copyWith(
          isSubmitting: true,
          failureOrSuccessOption: none(),
        ),
      );
      failureOrSuccess = await forwardedCall(
        email: state.email,
        password: state.password,
      );
    }
    emitter(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        failureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }

  Future<void> _performActionOnThirdPartyLogin({
    required Future<Either<Failure, Option<User>>> Function() forwardedCall,
    required Emitter<LogInFormState> emitter,
  }) async {
    emitter(
      state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      ),
    );
    final failureOrSuccess = await forwardedCall();
    emitter(
      failureOrSuccess.fold(
        (failure) => state.copyWith(
          isSubmitting: false,
          failureOrSuccessOption: some(left(failure)),
        ),
        (userOption) => state.copyWith(
          isSubmitting: false,
          thirdPartyUserOption: userOption,
          failureOrSuccessOption: none(),
        ),
      ),
    );
  }
}
