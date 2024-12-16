import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/application/authentication/authentication/authentication_bloc.dart';
import 'package:invitations_project/application/cart/cart/cart_bloc.dart';
import 'package:invitations_project/application/invitation_edition/invitation_edition/invitation_editor_bloc.dart';
import 'package:invitations_project/injection.dart';
import 'package:invitations_project/views/core/routes/router.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  AppWidget({super.key});

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    final showBanner = Provider.of<String>(context) != Environment.prod;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CartBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<InvitationEditorBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<AuthenticationBloc>()
            ..add(
              AuthenticationEvent.authenticationCheckRequested(),
            ),
        ),
      ],
      child: MaterialApp.router(
        title: "Invitaciones",
        debugShowCheckedModeBanner: showBanner,
        theme: ThemeData().copyWith(),
        routerDelegate: _router.delegate(),
        routeInformationParser: _router.defaultRouteParser(),
      ),
    );
  }
}
