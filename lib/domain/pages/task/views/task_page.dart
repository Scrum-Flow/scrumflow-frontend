import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/task/controllers/task_page_controller.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.projectId});

  final int projectId;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    TaskPageController controller = Get.put<TaskPageController>(
        TaskPageController(projectId: widget.projectId));

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            /*SearchField(
               onFieldSubmitted: controller.filterSubmitted,
              onClear: controller.filterSubmitted,
                ),*/
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: Row(
                        children: [
                          const Expanded(
                            child: BaseLabel(
                              text: 'Tarefas',
                              fontSize: fsVeryBig,
                              fontWeight: fwMedium,
                            ),
                          ),
                          PageBuilder(
                            minimumInsets: EdgeInsets.zero,
                            webPage: SizedBox(
                              width: 200,
                              child: BaseButton(
                                title: 'Criar Tarefa',

                                ///TODO: Modificar form de tarefas para poder escolher a funcionalidade
                                onPressed:
                                    () {}, /* => Routes.goTo(
                                    context,
                                    TaskFormPage(
                                      feature: feature,
                                    )),*/
                              ),
                            ),
                            mobilePage: IconButton(
                              tooltip: 'Nova Tarefa',
                              onPressed:
                                  () {} /*=> Routes.goTo(context, ProjectFormPage())*/,
                              icon: Icon(Icons.add_card_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _header(),
                    Obx(
                      () => controller.pageState.value.status ==
                              PageStatus.loading
                          ? 0.toSizedBoxH()
                          : _TaskList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    Get.delete<TaskPageController>();
    super.dispose();
  }

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                  flex: 10,
                  child: Text('Nome',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 10,
                  child: Text('Descrição',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 7,
                  child: Text('Responsável',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 2,
                  child: Text('Pontos',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 5,
                  child: Text('Status',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 4,
                  child: Text('Editar/Excluir',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Lista das funcionalidades e suas tarefas
            const TaskTable(),
          ],
        ),
      ),
    );
  }
}

class TaskTable extends StatefulWidget {
  const TaskTable({Key? key}) : super(key: key);

  @override
  _TaskTableState createState() => _TaskTableState();
}

class _TaskTableState extends State<TaskTable> {
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
                .map((task) => task.assignedFeature == feature.name
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _taskWidget(task))
                    : const Text("Nenhuma tarefa para essa funcionalidade"))
                .toList());
      }).toList(),
    );
  }

  Widget _taskWidget(Task task) {
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
            Expanded(flex: 5, child: Text(task.status ?? "ASTATAS")),
            Expanded(
                flex: 4,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Ação de edição
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
                                Navigator.of(context).pop();
                                /*controller.deleteTask(task);*/
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
