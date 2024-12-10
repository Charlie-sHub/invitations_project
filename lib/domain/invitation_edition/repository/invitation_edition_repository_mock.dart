import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import 'invitation_edition_repository_interface.dart';

@LazySingleton(
  as: InvitationEditionRepositoryInterface,
  env: [Environment.test],
)
class MockCartRepository extends Mock
    implements InvitationEditionRepositoryInterface {}
