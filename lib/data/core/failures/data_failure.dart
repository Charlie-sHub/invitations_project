import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:invitations_project/domain/core/validation/objects/email_address.dart';

part 'data_failure.freezed.dart';

@freezed
class DataFailure<T> with _$DataFailure<T> {
  const factory DataFailure.notFoundError() = NotFoundError<T>;

  const factory DataFailure.invalidCredentials() = InvalidCredentials<T>;

  const factory DataFailure.unregisteredUser() = UnregisteredUser<T>;

  const factory DataFailure.cancelledByUser() = CancelledByUser<T>;

  const factory DataFailure.serverError({
    required String errorString,
  }) = ServerError<T>;

  const factory DataFailure.cacheError({
    required String errorString,
  }) = CacheError<T>;

  const factory DataFailure.emailAlreadyInUse({
    required EmailAddress email,
  }) = EmailAlreadyInUse<T>;
}
