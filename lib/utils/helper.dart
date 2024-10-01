import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Helper {
  static double screenHeight() => Get.height;

  static double screenWidth() => Get.width;

  static bool isWeb() => isMobile() == false;

  static bool isMobile() {
    double width = Get.width;

    if (width < 1000) {
      return true;
    }

    if (GetPlatform.isMobile) {
      return true;
    }

    return false;
  }

  static String? formatDate(DateTime? dateTime) {
    if (dateTime == null) return null;

    DateFormat format = DateFormat('dd/MM/yyyy');

    return format.format(dateTime);
  }

  static String? schemaDate(DateTime? dateTime) {
    if (dateTime == null) return null;

    DateFormat format = DateFormat('yyyy-MM-dd');

    return format.format(dateTime);
  }

  static int daysBetween(DateTime? from, DateTime? to) {
    if (from == null || to == null) return 0;

    from = DateTime(from.year, from.month, from.day);

    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }

  static String formatPercent(double? value) {
    if (value == null) return '';

    if (value.isNegative || value.isNaN || value.isInfinite) {
      value = 0.0;
    }

    if (value > 1) {
      value = 1;
    }

    return '${(value * 100).toStringAsFixed(2)}%';
  }

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
