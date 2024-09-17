import 'package:flutter/material.dart';

const double fsSmall = 10.8;
const double fsNormal = 14;
const double fsBig = 16;
const double fsVeryBig = 24;

const FontWeight fwLight = FontWeight.w300;
const FontWeight fwNormal = FontWeight.normal;
const FontWeight fwMedium = FontWeight.w500;
const FontWeight fwBold = FontWeight.bold;

class BaseLabel extends StatelessWidget {
  const BaseLabel({
    super.key,
    required this.text,
    this.fontSize = fsNormal,
    this.fontWeight = fwNormal,
    this.color,
    this.decoration,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration? decoration;
  final TextOverflow overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        overflow: overflow,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
      ),
    );
  }
}
