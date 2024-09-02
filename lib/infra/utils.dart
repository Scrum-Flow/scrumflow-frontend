import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isWeb() {
  return isMobile() == false;
}

bool isMobile() {
  double width = Get.width;

  if (width < 1000) {
    return true;
  }

  if (GetPlatform.isMobile) {
    return true;
  }

  return false;
}

double screenHeight() => Get.height;

double screenWidth() => Get.width;

extension OnInt on int {
  Widget toSizedBoxH() => SizedBox(height: toDouble());

  Widget toSizedBoxW() => SizedBox(width: toDouble());
}
