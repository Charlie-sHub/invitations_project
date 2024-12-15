import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/views/core/routes/router.gr.dart';

class InvitationCard extends StatelessWidget {
  const InvitationCard({
    required this.invitation,
    super.key,
  });

  final Invitation invitation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(
        InvitationEditionRoute(invitation: invitation),
      ),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Card(
          surfaceTintColor: Colors.pinkAccent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(invitation.title.getOrCrash()),
                Text(invitation.id.getOrCrash()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
