import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import 'cart_repository_interface.dart';

@LazySingleton(
  as: CartRepositoryInterface,
  env: [Environment.test],
)
class MockCartRepository extends Mock implements CartRepositoryInterface {}
