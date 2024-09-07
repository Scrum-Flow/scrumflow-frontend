import 'package:get/get.dart';
import 'package:scrumflow/utils/utils.dart';

class Prompts {
  static void successSnackBar(String title, [String? message]) {
    _showSnackBar(title, message, true);
  }

  static void errorSnackBar(String title, [String? message]) {
    _showSnackBar(title, message, false);
  }

  static void _showSnackBar(String title, String? message, bool isSuccess) {
    Get.snackbar(
      title,
      message ?? 'Ocorreu um erro inesperado',
      backgroundColor:
          isSuccess ? AppTheme.successColor : AppTheme.theme.colorScheme.error,
      colorText:
          isSuccess ? AppTheme.onSuccess : AppTheme.theme.colorScheme.onError,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
