import 'package:flutter/material.dart';

class InvitationsProgressIndicator extends StatelessWidget {
  const InvitationsProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => const Center(
      child: CircularProgressIndicator.adaptive(),
    );
}
