import 'dart:ui';

import 'package:get/get.dart';
import 'package:scrumflow/utils/utils.dart';

class Prompts {
  static void showSnackBar(PageState state) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    switch (state.status) {
      case PageStatus.loading:
        alertSnackBar('Carregando...', state.info ?? '');
        break;
      case PageStatus.error:
        errorSnackBar('Erro', state.info);
        break;
      case PageStatus.success:
        successSnackBar('Sucesso', state.info ?? '');
        break;
      default:
        break;
    }
  }

  static void alertSnackBar(String title, [String? message]) {
    _showSnackBar(title, message, Color(0xffFB8C00),
        AppTheme.theme.colorScheme.onSecondary);
  }

  static void successSnackBar(String title, [String? message]) {
    _showSnackBar(title, message, AppTheme.successColor, AppTheme.onSuccess);
  }

  static void errorSnackBar(String title, [String? message]) {
    _showSnackBar(title, message, AppTheme.theme.colorScheme.error,
        AppTheme.theme.colorScheme.onError);
  }

  static void _showSnackBar(
      String title, String? message, Color backgroundColor, Color textColor) {
    Get.snackbar(
      title,
      message ?? 'Ocorreu um erro inesperado',
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
