import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/data/home/production_home_repository.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';

import 'production_home_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Logger>()])
void main() {
  late MockLogger mockLogger;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late ProductionHomeRepository repository;

  setUp(
    () {
      mockLogger = MockLogger();
      fakeFirebaseFirestore = FakeFirebaseFirestore();
      repository = ProductionHomeRepository(
        mockLogger,
        fakeFirebaseFirestore,
      );
    },
  );
}
