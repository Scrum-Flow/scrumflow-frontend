import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/models/feature.dart';
import 'package:scrumflow/models/task.dart';
import 'package:scrumflow/utils/enums/enum_status.dart';

class TaskTableWeb extends StatefulWidget {
  const TaskTableWeb({Key? key}) : super(key: key);

  @override
  _TaskTableState createState() => _TaskTableState();
}

class _TaskTableState extends State<TaskTableWeb> {
  TaskPageController controller = Get.find<TaskPageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: controller.featureValues.map((feature) {
        return ExpansionTile(
            title: Text(
              'Funcionalidade: ${feature.name}',
              textAlign: TextAlign.center,
            ),
            children: controller.tasksValues
                    .where((task) => task.assignedFeature == feature.name)
                    .toList()
                    .isEmpty
                ? [const Text("Nenhuma tarefa para essa funcionalidade")]
                : controller.tasksValues
                    .where((task) => task.assignedFeature == feature.name)
                    .map((task) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _taskWidget(task, feature),
                        ))
                    .toList());
      }).toList(),
    );
  }

  Widget _taskWidget(Task task, Feature feature) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.black38,
                height: 1,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 10, child: Text(task.name ?? "NOME AQ")),
            Expanded(flex: 10, child: Text(task.description ?? "DESC AQ")),
            Expanded(flex: 7, child: Text(task.assignedUser ?? "User AQ")),
            Expanded(flex: 2, child: Text(task.estimatePoints.toString())),
            Expanded(
                flex: 5, child: Text(ObjectStatus.getOsToString(task.status!))),
            Expanded(
                flex: 4,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: "Editar tarefa",
                      onPressed: () async {
                        var result = await Get.to(TaskFormPage(
                          feature: feature,
                          task: task,
                        ));
                        if (result != null) {
                          await controller.onInit();
                        }
                      },
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.black12,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                      ),
                      tooltip: 'Excluir',
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: BaseLabel(
                              text: 'Realmente deseja excluir esta tarefa?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: BaseLabel(text: 'Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.deleteTask(task.id!);
                                Navigator.of(context).pop();
                              },
                              child: BaseLabel(text: 'Confirmar'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ],
    );
  }
}
