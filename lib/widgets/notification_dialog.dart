import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/user/controllers/user_list_controller.dart';

class NotificationDialog extends StatefulWidget {
  NotificationDialog(this.userId, this.initialUserChoice, {super.key});

  int userId;
  bool initialUserChoice;

  @override
  NotificationDialogState createState() => NotificationDialogState();
}

class NotificationDialogState extends State<NotificationDialog> {
  UserListController userListController = Get.find<UserListController>();

  void _showNotificationDialog() {
    RxBool isChecked = RxBool(widget.initialUserChoice);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enviar notificações para o usuário?"),
          content: Row(
            children: [
              Obx(
                () => Checkbox(
                  value: isChecked.value,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked.value = value ?? false;
                    });
                  },
                ),
              ),
              const Text("Ativar notificações"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                userListController.patchUserNotification(
                    widget.userId, isChecked.value);

                Navigator.of(context).pop();
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications),
      onPressed: _showNotificationDialog,
      tooltip: "Configurar Notificações",
    );
  }
}
