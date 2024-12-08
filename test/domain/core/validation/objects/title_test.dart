import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/validation/objects/title.dart';
import '../../../../test_descriptions.dart';

void main() {
  const validName = "Test Test";
  const emptyName = "";
  const multiLineName = "Test \n Test";
  const tooLongName =
      "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTest";
  test(
    TestDescription.valid,
    () async {
      // Act
      final name = Title(validName);
      // Assert
      expect(name.isValid(), true);
      expect(name.getOrCrash(), validName);
    },
  );
  group(
    TestDescription.groupOnFailure,
    () {
      test(
        "${TestDescription.invalid} with tooLongName",
        () async {
          // Act
          final name = Title(tooLongName);
          // Assert
          expect(name.isValid(), false);
        },
      );
      test(
        "${TestDescription.invalid} with emptyName",
        () async {
          // Act
          final name = Title(emptyName);
          // Assert
          expect(name.isValid(), false);
        },
      );
      test(
        "${TestDescription.invalid} with multiLineName",
        () async {
          // Act
          final name = Title(multiLineName);
          // Assert
          expect(name.isValid(), false);
        },
      );
    },
  );
}
