import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/views/core/routes/router.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  AppWidget({super.key});

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    // TODO: Provide CartBloc and AuthenticationBloc
    final showBanner = Provider.of<String>(context) != Environment.prod;
    return MaterialApp.router(
      title: "Invitaciones",
      debugShowCheckedModeBanner: showBanner,
      theme: ThemeData().copyWith(),
      routerDelegate: _router.delegate(),
      routeInformationParser: _router.defaultRouteParser(),
    );
  }
}
