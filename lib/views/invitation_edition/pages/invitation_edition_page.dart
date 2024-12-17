import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invitations_project/views/home/widgets/invitations_app_bar.dart';
import 'package:invitations_project/views/invitation_edition/widgets/invitation_edition_form.dart';

@RoutePage()
class InvitationEditionPage extends StatelessWidget {
  const InvitationEditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InvitationsAppBar(),
      body: InvitationEditionForm(),
    );
  }
}
