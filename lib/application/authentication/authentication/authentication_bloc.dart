import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/domain/authentication/repository/authentication_repository_interface.dart';

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
              (_) => const AuthenticationState.authenticated(),
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
