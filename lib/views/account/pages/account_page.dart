import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/authentication/authentication/authentication_bloc.dart';
import 'package:invitations_project/application/authentication/login_form/log_in_form_bloc.dart';
import 'package:invitations_project/injection.dart';
import 'package:invitations_project/views/authentication/widgets/login_pop_up.dart';
import 'package:invitations_project/views/core/widgets/invitations_progress_indicator.dart';
import 'package:invitations_project/views/home/widgets/invitations_app_bar.dart';

@RoutePage()
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: _listener,
        builder: (context, state) => Scaffold(
          appBar: const InvitationsAppBar(),
          body: Center(
            child: state.when(
              initial: InvitationsProgressIndicator.new,
              unAuthenticated: () => const Text('No has entrado'),
              authenticated: (currentUser) => Text(
                currentUser.email.getOrCrash(),
              ),
            ),
          ),
        ),
      );

  Object? _listener(BuildContext context, AuthenticationState state) =>
      state.maybeWhen(
        unAuthenticated: () => showDialog(
          context: context,
          builder: (context) => BlocProvider(
            create: (context) => getIt<LogInFormBloc>(),
            child: const LoginPopUp(),
          ),
        ),
        orElse: () => null,
      );
}
