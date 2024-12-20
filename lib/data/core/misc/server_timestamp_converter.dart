import 'package:freezed_annotation/freezed_annotation.dart';

class ServerDateStringConverter implements JsonConverter<DateTime, String> {
  const ServerDateStringConverter();

  @override
  DateTime fromJson(String iso8601String) => DateTime.parse(iso8601String);

  @override
  String toJson(DateTime dateTime) => dateTime.toIso8601String();
}
