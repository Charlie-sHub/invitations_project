part of 'authentication_bloc.dart';

@freezed
class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.authenticationCheckRequested() =
      _AuthenticationCheckRequested;

  const factory AuthenticationEvent.loggedOut() = _LoggedOut;
}
