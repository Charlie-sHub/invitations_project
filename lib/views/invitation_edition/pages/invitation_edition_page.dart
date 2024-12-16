import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/invitation_edition/invitation_edition/invitation_editor_bloc.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/injection.dart';
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
      body: BlocProvider(
        create: (context) => getIt<InvitationEditorBloc>(
          param2: invitation,
        ),
        child: BlocConsumer<InvitationEditorBloc, InvitationEditorState>(
          listener: (context, state) {
            // TODO: implement listener
            // TODO: Pass the Invitation to the CartBloc
          },
          buildWhen: (previous, current) {
            // TODO: Implement buildWhen
            return true;
          },
          builder: (context, state) => Column(
            children: [
              Text("INVITATION EDITION"),
              TextButton(
                onPressed: () => context.router.push(const CartRoute()),
                child: Text("Hecho"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
