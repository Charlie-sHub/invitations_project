import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:invitations_project/firebase_options.dart';
import 'package:invitations_project/injection.dart';
import 'package:invitations_project/views/core/widgets/app_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

/// Common entry point for the application.
Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(environment);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(
    Provider(
      create: (context) => environment,
      child: AppWidget(),
    ),
  );
}
