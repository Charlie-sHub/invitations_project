import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class LoggerInjectableModule {
  @lazySingleton
  Logger get logger => Logger();
}
