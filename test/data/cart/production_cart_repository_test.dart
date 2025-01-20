import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/data/cart/production_cart_repository.dart';
import 'package:invitations_project/data/core/misc/firebase/cloud_storage/cloud_storage_service.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';

import 'production_cart_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<CloudStorageService>(),
])
void main() {
  late MockLogger mockLogger;
  late MockCloudStorageService mockCloudStorage;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late ProductionCartRepository repository;

  setUp(
    () {
      mockLogger = MockLogger();
      mockCloudStorage = MockCloudStorageService();
      fakeFirebaseFirestore = FakeFirebaseFirestore();
      repository = ProductionCartRepository(
        mockLogger,
        fakeFirebaseFirestore,
        mockCloudStorage,
      );
    },
  );
}
