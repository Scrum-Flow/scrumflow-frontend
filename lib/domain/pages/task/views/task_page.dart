import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/pages.dart';
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
                                  onPressed: () async {
                                    var result =
                                        await Get.toNamed(Routes.taskFormPage);

                                    if (result == true) {
                                      await controller.onInit();
                                    }
                                  }),
                            ),
                            mobilePage: IconButton(
                              tooltip: 'Nova Tarefa',
                              onPressed: () async {
                                var result =
                                    await Get.toNamed(Routes.taskFormPage);

                                if (result == true) {
                                  await controller.onInit();
                                }
                              },
                              icon: Icon(Icons.add_card_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Helper.isMobile() ? _headerMobile() : _headerWeb(),
                    Obx(
                      () => controller.pageState.value.status ==
                              PageStatus.loading
                          ? const CircularProgressIndicator()
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

  Widget _headerMobile() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                  flex: 2,
                  child: Text('Nome',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 1,
                  child: Text('Editar/Excluir',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _headerWeb() {
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
                  child: Text("Histórico",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 2,
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
            Helper.isMobile() ? TaskTableMobile() : TaskTableWeb(),
          ],
        ),
      ),
    );
  }
}
