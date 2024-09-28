import 'package:get/get.dart';

class JsonHelper {
  static bool? toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return null;
  }

  static DateTime? toDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  static T? toEnum<T>(List<T> values, dynamic value, {int? base}) {
    if (value is int) {
      return values[value];
    }

    if (value is String) {
      return values.firstWhere((element) => (element as Enum).name == value.camelCase);
    }

    if (base != null) {
      return values[base];
    }

    return null;
  }

  static T? keyExists<T>(Map json, String key) {
    return json.containsKey(key) ? json[key] : null;
  }
}
