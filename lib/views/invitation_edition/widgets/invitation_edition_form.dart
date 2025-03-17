import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/cart/cart/cart_bloc.dart';
import 'package:invitations_project/application/invitation_edition/invitation_edition/invitation_editor_bloc.dart';
import 'package:invitations_project/views/core/routes/router.gr.dart';

class InvitationEditionForm extends StatelessWidget {
  const InvitationEditionForm({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<InvitationEditorBloc, InvitationEditorState>(
        listenWhen: (_, current) => current.hasSubmitted,
        listener: _invitationEditionListener,
        // TODO: Implement buildWhen
        // Build should only be called when the state would change the UI
        buildWhen: (previous, current) => true,
        builder: (context, state) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.invitation.title.getOrCrash()),
              TextButton(
                onPressed: () => context.read<InvitationEditorBloc>().add(
                      const InvitationEditorEvent.submitted(),
                    ),
                child: const Text('Hecho'),
              ),
            ],
          ),
        ),
      );

  void _invitationEditionListener(
    BuildContext context,
    InvitationEditorState state,
  ) {
    if (state.hasSubmitted) {
      context.read<InvitationEditorBloc>().add(
            const InvitationEditorEvent.unSubmitted(),
          );
      context.read<CartBloc>().add(
            CartEvent.addedInvitation(state.invitation),
          );
      context.router.push(const CartRoute());
    }
  }
}
