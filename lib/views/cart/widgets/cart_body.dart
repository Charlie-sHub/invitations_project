import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/cart/cart/cart_bloc.dart';
import 'package:invitations_project/injection.dart';
import 'package:invitations_project/views/cart/widgets/simple_invitation_card.dart';
import 'package:invitations_project/views/core/routes/router.gr.dart';
import 'package:logger/logger.dart';

class CartBody extends StatelessWidget {
  const CartBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listenWhen: (_, current) => current.failureOrSuccessOption.isSome(),
      listener: _cartListener,
      buildWhen: (previous, current) {
        // TODO: Implement buildWhen
        // Build should only be called when the state would change the UI
        return true;
      },
      builder: (context, state) {
        // TODO: Implement HydratedBlocs to keep the state
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Tu carrito'),
                const SizedBox(height: 30),
                state.invitationOption.fold(
                  () => Text("Tu carrito esta vacio"),
                  (invitation) => Column(
                    children: [
                      SimpleInvitationCard(
                        invitation: invitation,
                      ),
                      const SizedBox(height: 50),
                      TextButton(
                        onPressed: () => context.read<CartBloc>().add(
                              CartEvent.purchased(),
                            ),
                        child: Text("Compra"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _cartListener(BuildContext context, CartState state) {
    state.failureOrSuccessOption.fold(
      () {},
      (either) => either.fold(
        (failure) => getIt<Logger>().e(
          "Error purchasing Invitation: $failure",
        ),
        (_) => state.invitationOption.fold(
          () => getIt<Logger>().e(
            "Error purchasing Invitation: Purchased with empty Cart",
          ),
          (invitation) {
            context.read<CartBloc>().add(CartEvent.emptied());
            context.router.push(
              InvitationViewRoute(id: invitation.id.getOrCrash()),
            );
          },
        ),
      ),
    );
  }
}
