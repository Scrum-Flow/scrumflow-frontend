import 'package:flutter/material.dart';
import 'package:scrumflow/widgets/base_label.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseLabel(
            text: 'Dashboards', fontSize: fsVeryBig, fontWeight: fwMedium),
      ),
    );
  }
}
