import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:invitations_project/injection.dart';
import 'package:invitations_project/views/core/widgets/app_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  /*
  In app purchasing in android requires this
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
   */
  configureDependencies(environment);
  // Firebase use requires this
  // await Firebase.initializeApp();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  runApp(
    Provider(
      create: (context) => environment,
      child: AppWidget(),
    ),
  );
}
