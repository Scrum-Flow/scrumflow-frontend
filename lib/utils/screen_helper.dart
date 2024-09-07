import 'package:get/get.dart';

class ScreenHelper {
  static bool isWeb() {
    return isMobile() == false;
  }

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

  static double screenHeight() => Get.height;

  static double screenWidth() => Get.width;
}
