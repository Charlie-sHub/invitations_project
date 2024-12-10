import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import 'home_repository_interface.dart';

@LazySingleton(
  as: HomeRepositoryInterface,
  env: [Environment.test],
)
class MockHomeRepository extends Mock implements HomeRepositoryInterface {}
