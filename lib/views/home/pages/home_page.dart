import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invitations_project/views/home/widgets/home_body.dart';
import 'package:invitations_project/views/home/widgets/invitations_app_bar.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
      appBar: InvitationsAppBar(),
      body: HomeBody(),
    );
}
