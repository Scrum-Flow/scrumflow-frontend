import 'package:flutter/material.dart';
import 'package:scrumflow/utils/screen_helper.dart';
import 'package:scrumflow/widgets/base_label.dart';

enum ButtonType {
  primary(Color(0xff020819)),
  secondary(Color(0xff0A2E43));

  final Color color;

  const ButtonType(this.color);
}

class BaseButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final IconData? iconData;
  final ButtonType type;
  final bool isLoading;

  const BaseButton({
    super.key,
    required this.title,
    this.iconData,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: ScreenHelper.isMobile() ? 100 : 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: type.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size.fromHeight(44),
        ),
        onPressed: isLoading ? () {} : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : BaseLabel(
                text: title,
                color: Colors.white,
                fontWeight: fwMedium,
                fontSize: fsBig,
              ),
      ),
    );
  }
}
