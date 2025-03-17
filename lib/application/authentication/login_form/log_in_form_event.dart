part of 'log_in_form_bloc.dart';

@freezed
class LogInFormEvent with _$LogInFormEvent {
  const factory LogInFormEvent.emailChanged(
    String email,
  ) = _EmailChanged;

  const factory LogInFormEvent.passwordChanged(
    String password,
  ) = _PasswordChanged;

  const factory LogInFormEvent.registered() = _Registered;

  const factory LogInFormEvent.loggedIn() = _LoggedIn;

  const factory LogInFormEvent.loggedInGoogle() = _LoggedInGoogle;

  const factory LogInFormEvent.loggedInApple() = _LoggedInApple;
}
