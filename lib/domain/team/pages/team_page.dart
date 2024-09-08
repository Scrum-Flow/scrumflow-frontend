import 'package:flutter/material.dart';
import 'package:scrumflow/widgets/base_label.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseLabel(
            text: 'Times', fontSize: fsVeryBig, fontWeight: fwMedium),
      ),
    );
  }
}
