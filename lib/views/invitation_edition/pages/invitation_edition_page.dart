import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/views/core/routes/router.gr.dart';
import 'package:invitations_project/views/home/widgets/invitations_app_bar.dart';

@RoutePage()
class InvitationEditionPage extends StatelessWidget {
  const InvitationEditionPage({
    required this.invitation,
    super.key,
  });

  final Invitation invitation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InvitationsAppBar(),
      body: Center(
        child: Column(
          children: [
            Text("INVITATION EDITION"),
            TextButton(
              onPressed: () => context.router.push(const CartRoute()),
              child: Text("Hecho"),
            ),
          ],
        ),
      ),
    );
  }
}
