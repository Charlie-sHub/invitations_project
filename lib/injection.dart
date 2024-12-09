import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies(String env) => getIt.init(environment: env);
