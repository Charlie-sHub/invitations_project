import 'package:flutter/material.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/views/home/widgets/invitation_card.dart';

class ExamplesGrid extends StatelessWidget {
  const ExamplesGrid({
    required this.invitations,
    super.key,
  });

  final List<Invitation> invitations;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      padding: EdgeInsets.all(200),
      itemCount: invitations.length,
      itemBuilder: (context, index) => InvitationCard(
        invitation: invitations[index],
      ),
    );
  }
}
