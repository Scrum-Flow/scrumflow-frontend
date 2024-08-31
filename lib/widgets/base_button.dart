import 'package:flutter/material.dart';

enum ButtonType {
  primary(Colors.grey),
  secondary(Color(0xff000000));

  final Color color;

  const ButtonType(this.color);
}

class BaseButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final IconData? iconData;
  final ButtonType type;

  const BaseButton({
    super.key,
    required this.title,
    this.iconData,
    this.onPressed,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: type.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size.fromHeight(44),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: type == ButtonType.primary
                ? const Color(0xff363435)
                : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
