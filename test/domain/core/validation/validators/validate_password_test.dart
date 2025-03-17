import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/failures/value_failure.dart';
import 'package:invitations_project/domain/core/validation/validators/validate_password.dart';

void main() {
  const validPassword = 'abc*1234';
  const invalidPass = 'a';
  test(
    'Should return the valid password',
    () async {
      // Act
      final result = _act(validPassword);
      // Assert
      expect(result, validPassword);
    },
  );
  test(
    'Should return InvalidPassword',
    () async {
      // Act
      final result = _act(invalidPass);
      // Assert
      expect(
        result,
        const ValueFailure<String>.invalidPassword(failedValue: invalidPass),
      );
    },
  );
}

Object _act(String input) {
  final either = validatePassword(input);
  final result = either.fold(
    (valueFailure) => valueFailure,
    (validInput) => validInput,
  );
  return result;
}
