import 'package:flutter/material.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';

class SimpleInvitationCard extends StatelessWidget {
  const SimpleInvitationCard({
    required this.invitation,
    super.key,
  });

  final Invitation invitation;

  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(invitation.title.getOrCrash()),
            const SizedBox(height: 10),
            Text('ID: ${invitation.id.getOrCrash()}'),
            const Text('Precio: €XX.XX'),
          ],
        ),
      ),
    );
}
