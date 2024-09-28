import 'package:flutter/material.dart';
import 'package:scrumflow/utils/screen_helper.dart';

class PageBuilder extends StatelessWidget {
  const PageBuilder({
    super.key,
    required this.mobilePage,
    required this.webPage,
    this.minimumInsets,
  });

  final Widget mobilePage;
  final Widget webPage;
  final EdgeInsets? minimumInsets;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: minimumInsets ?? const EdgeInsets.symmetric(vertical: 18),
      child: LayoutBuilder(builder: (context, constraints) => ScreenHelper.isMobile() ? mobilePage : webPage),
    );
  }
}
