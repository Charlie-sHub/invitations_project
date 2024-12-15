import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Maybe this whole page is not necessary
// At least not for the Web app, a pop up should be enough
@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("LOGIN"),
      ),
    );
  }
}
