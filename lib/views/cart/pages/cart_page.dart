import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invitations_project/views/cart/widgets/cart_body.dart';
import 'package:invitations_project/views/home/widgets/invitations_app_bar.dart';

@RoutePage()
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
      appBar: InvitationsAppBar(),
      body: CartBody(),
    );
}
