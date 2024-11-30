import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/base_label.dart';
import 'package:scrumflow/domain/pages/kanban/controllers/kanban_controller.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/enums/enum_status.dart';
import 'package:scrumflow/utils/utils.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({
    required this.project,
    super.key,
  });

  final Project project;

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  late Future<void> controller;

  @override
  void initState() {
    controller = Get.put(KanbanController(widget.project)).onInit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: controller,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os dados'));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const BaseLabel(
                  text: 'Kanban', fontSize: fsVeryBig, fontWeight: fwMedium),
            ),
            body: _KanbanBoard(),
          );
        });
  }

  @override
  void dispose() {
    Get.delete<KanbanController>();

    super.dispose();
  }
}

class _KanbanBoard extends StatefulWidget {
  @override
  State<_KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<_KanbanBoard> {
  final KanbanController controller = Get.find<KanbanController>();

  Map<ObjectStatus, bool> visibilityStatus = {
    for (var status in ObjectStatus.values) status: true,
  };

  @override
  void initState() {
    super.initState();
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Visibilidade das Listas"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ObjectStatus.values.map((status) {
                  return CheckboxListTile(
                    title: Text(status.getDescription()),
                    value: visibilityStatus[status],
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          visibilityStatus[status] = value;
                        });
                        setDialogState(() {});
                      }
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Fechar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(
        () => controller.pageState.value.status == PageStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: DropdownButtonFormField<SprintDetails>(
                            hint: const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text("Selecione uma sprint"),
                            ),
                            value: controller.selectedSprint.value,
                            items: controller.sprintTasks.keys
                                .map(
                                  (sprint) => DropdownMenuItem(
                                    value: sprint,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: BaseLabel(text: sprint.name ?? ''),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (sprint) async {
                              controller.onChangeSprintSelected(sprint);
                            },
                            icon: IconButton(
                              onPressed: () async =>
                                  await controller.onChangeSprintSelected(null),
                              icon: const Icon(Icons.highlight_remove),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: _showSettingsDialog,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: Helper.screenWidth() * 0.95,
                        minWidth: Helper.screenWidth() * 0.95,
                      ),
                      child: Obx(
                        () => controller.statusTaskMap.isNotEmpty
                            ? DragAndDropLists(
                                listWidth: 180,
                                axis: Axis.horizontal,
                                disableScrolling: false,
                                itemDivider:
                                    const Divider(thickness: 1, height: 1),
                                listDragOnLongPress: false,
                                onItemReorder: _onItemReorder,
                                onListReorder: (_, __) {},
                                children: createDragAndDropLists(),
                                // itemDraggingWidth: 200,
                                listPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                listDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade400,
                                        blurRadius: 4),
                                  ],
                                ),
                              )
                            : 0.toSizedBoxW(),
                      ),
                    ),
                  ),
                  /*),*/
                ],
              ),
      ),
    );
  }

  Future<void> _onItemReorder(int oldItemIndex, int oldListIndex,
      int newItemIndex, int newListIndex) async {
    final oldStatus = ObjectStatus.values[oldListIndex];
    final newStatus = ObjectStatus.values[newListIndex];

    await controller.updateTaskStatus(
        oStatus: oldStatus,
        oIndex: oldItemIndex,
        nStatus: newStatus,
        nIndex: newItemIndex);
  }

  List<DragAndDropList> createDragAndDropLists() {
    return ObjectStatus.values
        .where((status) => visibilityStatus[status] ?? false)
        .map((status) {
      return DragAndDropList(
        contentsWhenEmpty: const Text("Sem tarefas"),
        canDrag: false,
        header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.lightbulb_circle),
              10.toSizedBoxW(),
              Text(
                status.getDescription(),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        children: controller.statusTaskMap[status]!.map((task) {
          return DragAndDropItem(
            child: _card(
                title: task.name ?? 'Sem nome',
                subtitle: task.description ?? 'Sem descrição',
                sprint: controller.getSprintName(task.id),
                feature: controller.getFeatureName(task.id),
                responsible: task.assignedUser),
          );
        }).toList(),
      );
    }).toList();
  }

  Widget _card({
    required String title,
    required String subtitle,
    required String sprint,
    required String feature,
    required String responsible,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 165,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            8.toSizedBoxH(),
            Tooltip(
              message: "Sprint",
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  sprint,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            8.toSizedBoxH(),
            Tooltip(
              message: "Funcionalidade",
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  feature,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            8.toSizedBoxH(),
            Tooltip(
              message: "Responsável",
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  responsible,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
