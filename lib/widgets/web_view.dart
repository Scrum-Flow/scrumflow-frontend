import 'package:flutter/material.dart';

class WebView extends StatelessWidget {
  const WebView(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: child,
      ),
    );
  }
}
