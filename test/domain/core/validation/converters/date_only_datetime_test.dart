import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invitations_project/domain/core/validation/converters/date_only_datetime.dart';

void main() {
  test(
    'Should make all the units of time of less than a day equal 0',
        () async {
      // Act
      final either = dateOnlyDateTime(DateTime.now());
      final result = either.fold(
            (l) => null,
        id,
      );
      // Assert
      expect(result!.millisecond, 0);
      expect(result.second, 0);
      expect(result.minute, 0);
      expect(result.microsecond, 0);
      expect(result.hour, 0);
    },
  );
}
