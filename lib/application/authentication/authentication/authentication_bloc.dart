import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/domain/authentication/repository/authentication_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/user.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

part 'authentication_bloc.freezed.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepositoryInterface _repository;

  AuthenticationBloc(this._repository)
      : super(const AuthenticationState.initial()) {
    on<AuthenticationEvent>(
      (event, emit) => event.when(
        authenticationCheckRequested: () async {
          final userOption = await _repository.getLoggedInUser();
          emit(
            userOption.fold(
              () => const AuthenticationState.unAuthenticated(),
              (user) => AuthenticationState.authenticated(user),
            ),
          );
          return null;
        },
        loggedOut: () async {
          await _repository.logOut();
          emit(const AuthenticationState.unAuthenticated());
          return null;
        },
      ),
    );
  }
}
