import 'package:get/get.dart';
import 'package:scrumflow/models/user.dart';

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

  static T? keyExists<T>(Map json, String key) {
    return json.containsKey(key) ? json[key] : null;
  }

  static UserCategory toUserCategory(dynamic value) {
    return UserCategory.values.firstWhereOrNull((e) => e == value) ??
        UserCategory.user;
  }
}
