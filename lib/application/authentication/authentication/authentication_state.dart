part of 'authentication_bloc.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.initial() = _Initial;

  const factory AuthenticationState.unAuthenticated() = _UnAuthenticated;

  const factory AuthenticationState.authenticated(
    User currentUser,
  ) = _Authenticated;
}
