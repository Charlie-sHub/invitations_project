import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/cart/cart/cart_bloc.dart';
import 'package:invitations_project/application/invitation_edition/invitation_edition/invitation_editor_bloc.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/injection.dart';
import 'package:invitations_project/views/core/routes/router.gr.dart';
import 'package:invitations_project/views/home/widgets/invitations_app_bar.dart';
import 'package:logger/logger.dart';

@RoutePage()
class InvitationEditionPage extends StatelessWidget {
  const InvitationEditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InvitationsAppBar(),
      body: BlocConsumer<InvitationEditorBloc, InvitationEditorState>(
        listenWhen: (_, current) => current.failureOrSuccessOption.isSome(),
        listener: (context, state) => state.failureOrSuccessOption.fold(
          () {},
          (either) {
            either.fold(
              (failure) => getIt<Logger>().e(
                "Error creating Invitation: $failure",
              ),
              (_) {
                context.read<CartBloc>().add(
                      CartEvent.addedInvitation(state.invitation),
                    );
                context.router.push(CartRoute());
              },
            );
          },
        ),
        buildWhen: (previous, current) {
          // TODO: Implement buildWhen
          // Build should only be called when the state would change the UI
          return true;
        },
        builder: (context, state) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
