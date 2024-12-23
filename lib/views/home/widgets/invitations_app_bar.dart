import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invitations_project/views/core/routes/router.gr.dart';

class InvitationsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InvitationsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Invitaciones"),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () => context.router.push(const AccountRoute()),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => context.router.push(const InvitationEditionRoute()),
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => context.router.push(const CartRoute()),
        ),
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.router.push(const HomeRoute()),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight - 15);
}
