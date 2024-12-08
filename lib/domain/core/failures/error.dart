import 'package:invitations_project/domain/core/failures/value_failure.dart';

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    const explanation =
        "Encountered an unexpected value from an unrecoverable point";
    return Error.safeToString("$explanation: $valueFailure");
  }
}

class UnAuthenticatedError extends Error {
  @override
  String toString() {
    const explanation =
        "Couldn't get the authenticated User at a point where only authenticated Users should be";
    return Error.safeToString(explanation);
  }
}
