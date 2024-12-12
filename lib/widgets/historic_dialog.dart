import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/task/controllers/task_page_controller.dart';
import 'package:scrumflow/utils/enums/enum_status.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/loading_widget.dart';

class HistoryDialog extends StatefulWidget {
  HistoryDialog(this.taskId);

  int? taskId;

  @override
  HistoryDialogState createState() => HistoryDialogState();
}

class HistoryDialogState extends State<HistoryDialog> {
  TaskPageController controller = Get.find<TaskPageController>();

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingWidget(
          isLoading:
              controller.taskHistoryState.value.status == PageStatus.loading,
          child: Dialog(
            child: Container(
              width: Helper.screenWidth() * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Histórico de movimentações da tarefa",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("ID",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 2,
                            child: Text("Task ID",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 4,
                            child: Text("Usuário",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 4,
                            child: Text("De Status",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 4,
                            child: Text("Para Status",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 4,
                            child: Text("Quando",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: controller.taskHystory.isEmpty
                        ? const Center(
                            child: Text("Sem movimentações",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)))
                        : ListView.builder(
                            itemCount: controller.taskHystory.length,
                            itemBuilder: (context, index) {
                              final item = controller.taskHystory[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Text(item.id.toString())),
                                    Expanded(
                                        flex: 2,
                                        child: Text(item.taskId.toString())),
                                    Expanded(
                                        flex: 4, child: Text(item.userName!)),
                                    Expanded(
                                        flex: 4,
                                        child: Text(ObjectStatus.getOsToString(
                                            item.fromStatus!))),
                                    Expanded(
                                        flex: 4,
                                        child: Text(ObjectStatus.getOsToString(
                                            item.toStatus!))),
                                    Expanded(
                                        flex: 4,
                                        child: Text(item.movedAt.toString())),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.history),
      onPressed: () async {
        await controller.getTasksHistory(widget.taskId ?? 0);
        _showHistoryDialog();
      },
      tooltip: "Ver Histórico",
    );
  }
}
