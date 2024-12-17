import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_failure.freezed.dart';

@freezed
class ApplicationFailure<T> with _$ApplicationFailure<T> {
  const factory ApplicationFailure.emptyCart() = EmptyCart<T>;
}
