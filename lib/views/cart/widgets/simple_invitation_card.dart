import 'package:flutter/material.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';

class SimpleInvitationCard extends StatelessWidget {
  const SimpleInvitationCard({
    required this.invitation,
    super.key,
  });

  final Invitation invitation;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(invitation.title.getOrCrash()),
            const SizedBox(height: 10),
            const Text('Precio: \€XX.XX'),
          ],
        ),
      ),
    );
  }
}
