import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/models/feature.dart';
import 'package:scrumflow/models/task.dart';
import 'package:scrumflow/utils/enums/enum_status.dart';

class TaskTableMobile extends StatefulWidget {
  const TaskTableMobile({Key? key}) : super(key: key);

  @override
  _TaskTableState createState() => _TaskTableState();
}

class _TaskTableState extends State<TaskTableMobile> {
  TaskPageController controller = Get.find<TaskPageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: controller.featureValues.map((feature) {
        return ExpansionTile(
            title: Text(
              feature.name ?? "Funcionalidade",
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
        ExpansionTile(
          title: Row(
            children: [
              Expanded(child: Text(task.name ?? "NOME da Tarefa")),
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
                icon: const Icon(Icons.delete_outline_rounded),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Descrição: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .black, // Certifique-se de usar a cor desejada
                          ),
                        ),
                        TextSpan(
                          text: task.description,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Responsável: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: task.assignedUser,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Pontos Estimados: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: task.estimatePoints.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Status: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ObjectStatus.getOsToString(task.status!),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
