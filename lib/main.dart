import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/injection.dart';
import 'package:invitations_project/views/core/widgets/app_widget.dart';

@Deprecated('Prefer the use of either main dev or prod to run the app')
void main() {
  configureDependencies(Environment.dev);
  runApp(AppWidget());
}
