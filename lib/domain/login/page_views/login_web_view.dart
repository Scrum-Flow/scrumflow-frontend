import 'package:flutter/material.dart';
import 'package:scrumflow/domain/login/login_page.dart';

extension LoginPageWeb on LoginState {
  Widget buildWeb() {
    return Center(
      child: Container(
        width: 400,
        height: 800,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: addBody(),
      ),
    );
  }
}
