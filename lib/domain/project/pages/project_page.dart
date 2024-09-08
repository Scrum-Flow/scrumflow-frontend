import 'package:flutter/material.dart';
import 'package:scrumflow/widgets/base_label.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseLabel(
            text: 'Projetos', fontSize: fsVeryBig, fontWeight: fwMedium),
      ),
    );
  }
}
