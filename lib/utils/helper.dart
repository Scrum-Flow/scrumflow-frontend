import 'package:intl/intl.dart';

class Helper {
  static String? formatDate(DateTime? dateTime) {
    if (dateTime == null) return null;

    DateFormat format = DateFormat('dd/MM/yyyy');

    return format.format(dateTime);
  }
}
