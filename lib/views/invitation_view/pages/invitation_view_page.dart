import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../home/widgets/invitations_app_bar.dart';

@RoutePage()
class InvitationViewPage extends StatelessWidget {
  const InvitationViewPage({
    @PathParam('id') required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InvitationsAppBar(),
      body: Center(
        child: Text("INVITATION VIEW"),
      ),
    );
  }
}
