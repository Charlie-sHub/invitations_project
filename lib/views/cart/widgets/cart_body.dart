import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invitations_project/application/cart/cart/cart_bloc.dart';
import 'package:invitations_project/views/cart/widgets/simple_invitation_card.dart';

class CartBody extends StatelessWidget {
  const CartBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      buildWhen: (previous, current) {
        // TODO: Implement buildWhen
        // Build should only be called when the state would change the UI
        return true;
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Tu carrito'),
              const SizedBox(height: 30),
              state.invitationOption.fold(
                () => Text("ERROR"),
                (invitation) => SimpleInvitationCard(invitation: invitation),
              ),
            ],
          ),
        );
      },
    );
  }
}
