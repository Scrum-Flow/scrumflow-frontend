import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension OnInt on int {
  Widget toSizedBoxH() => SizedBox(height: toDouble());

  Widget toSizedBoxW() => SizedBox(width: toDouble());
}

extension FormateDateTime on DateTime {
  String get toDDMMYYYY => _formateDateTime(this, 'dd/MM/yyyy');

  String get toYYYYMMDD => _formateDateTime(this, 'yyyy-MM-dd');
}

String _formateDateTime(DateTime data, String formato) {
  final DateFormat formatter = DateFormat(formato);
  final String formatted = formatter.format(data);
  return formatted;
}
