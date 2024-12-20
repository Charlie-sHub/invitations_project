import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/domain/authentication/repository/authentication_repository_interface.dart';
import 'package:logger/logger.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

part 'authentication_bloc.freezed.dart';

@injectable
class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepositoryInterface _repository;
  final Logger _logger;

  AuthenticationBloc(this._repository, this._logger)
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

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    try {
      final state = json['state'] as String?;
      switch (state) {
        case 'initial':
          return const AuthenticationState.initial();
        case 'authenticated':
          return const AuthenticationState.authenticated();
        case 'unAuthenticated':
          return const AuthenticationState.unAuthenticated();
        default:
          return const AuthenticationState.initial();
      }
    } catch (error) {
      _logger.e('Could not restore AuthenticationState from JSON: $error');
      return const AuthenticationState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) => {
        'state': state.when(
          initial: () => 'initial',
          authenticated: () => 'authenticated',
          unAuthenticated: () => 'unAuthenticated',
        ),
      };
}
