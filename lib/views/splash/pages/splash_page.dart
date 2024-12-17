import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/authentication/authentication/authentication_bloc.dart';
import 'package:invitations_project/views/core/routes/router.gr.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: _splashListener,
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  void _splashListener(BuildContext context, AuthenticationState state) {
    state.map(
      initial: (_) => null,
      authenticated: (_) => context.router.replace(const HomeRoute()),
      unAuthenticated: (_) => context.router.replace(const SignInRoute()),
    );
  }
}
