import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/validation/objects/future_date.dart';

import '../../../../test_descriptions.dart';

void main() {
  final validDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).add(const Duration(days: 50));
  final invalidDate = DateTime.now().subtract(const Duration(days: 50));
  test(
    TestDescription.valid,
    () async {
      // Act
      final dateTime = FutureDate(validDate);
      // Assert
      expect(dateTime.isValid(), true);
    },
  );
  test(
    TestDescription.invalid,
    () async {
      // Act
      final dateTime = FutureDate(invalidDate);
      // Assert
      expect(dateTime.isValid(), false);
    },
  );
}
