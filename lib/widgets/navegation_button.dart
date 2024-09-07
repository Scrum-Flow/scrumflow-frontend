import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrumflow/utils/utils.dart';

class NavigationButton extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onPressed;

  const NavigationButton({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 25,
        height: 25,
      ),
      title: Text(title),
      onTap: onPressed,
      hoverColor: AppTheme.ligthBlueScrum,
    );
  }
}
