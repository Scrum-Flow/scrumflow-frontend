import 'package:intl/intl.dart';

class Helper {
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

    return '${(value * 100).toStringAsFixed(2)}%';
  }
}
