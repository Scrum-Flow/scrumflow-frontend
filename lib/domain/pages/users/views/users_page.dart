import 'package:flutter/material.dart';
import 'package:scrumflow/widgets/base_label.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseLabel(
            text: 'Usuários', fontSize: fsVeryBig, fontWeight: fwMedium),
      ),
    );
  }
}
