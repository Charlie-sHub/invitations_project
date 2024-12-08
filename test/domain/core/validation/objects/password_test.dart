import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/validation/objects/password.dart';

import '../../../../test_descriptions.dart';

void main() {
  const validPassword = "abcd*1234";
  const emptyPassword = "";
  const multiLinePassword = "abcd \n * \n 1234";
  const tooShortPassword = "a";
  const tooLongPassword =
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  test(
    TestDescription.valid,
    () async {
      // Act
      final password = Password(validPassword);
      // Assert
      expect(password.isValid(), true);
      expect(password.getOrCrash(), validPassword);
    },
  );
  group(
    TestDescription.groupOnFailure,
    () {
      test(
        "${TestDescription.invalid} with tooShortPassword",
        () async {
          // Act
          final password = Password(tooShortPassword);
          // Assert
          expect(password.isValid(), false);
        },
      );
      test(
        "${TestDescription.invalid} with tooLongPassword",
        () async {
          // Act
          final password = Password(tooLongPassword);
          // Assert
          expect(password.isValid(), false);
        },
      );
      test(
        "${TestDescription.invalid} with emptyPassword",
        () async {
          // Act
          final password = Password(emptyPassword);
          // Assert
          expect(password.isValid(), false);
        },
      );
      test(
        "${TestDescription.invalid} with multiLinePassword",
        () async {
          // Act
          final password = Password(multiLinePassword);
          // Assert
          expect(password.isValid(), false);
        },
      );
    },
  );
}
