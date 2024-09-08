import 'package:flutter/material.dart';
import 'package:scrumflow/widgets/base_label.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseLabel(
            text: 'Tarefas', fontSize: fsVeryBig, fontWeight: fwMedium),
      ),
    );
  }
}
