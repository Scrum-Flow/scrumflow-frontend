import 'package:appflowy_board/appflowy_board.dart';
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
  @override
  Widget build(BuildContext context) {
    Get.put(KanbanController(widget.project));

    return Scaffold(
      appBar: AppBar(
        title: const BaseLabel(
            text: 'Kanban', fontSize: fsVeryBig, fontWeight: fwMedium),
      ),
      body: _KanbanBoard(),
    );
  }
}

class _KanbanBoard extends StatefulWidget {
  @override
  State<_KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<_KanbanBoard> {
  final KanbanController controller = Get.find<KanbanController>();

  late List<DragAndDropList> _lists;

  ///Esse cara vai ter que ser salvo no bd -> E vai ter que ser obtido também
  Map<ObjectStatus, bool> visibilityStatus = {
    for (var status in ObjectStatus.values) status: true,
  };

  @override
  void initState() {
    super.initState();

    _initializeLists();
  }

  void _initializeLists() {
    _lists = ObjectStatus.values.map((status) {
      return DragAndDropList(
        contentsWhenEmpty: const Text("Sem tarefas"),
        // footer:
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
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        children: [
          DragAndDropItem(
            child: _card('Titulo Tarefa', 'Subtitulo Tarefa'),
          ),
          DragAndDropItem(
            child: _card('Titulo Tarefa', 'Subtitulo Tarefa'),
          ),
        ],
      );
    }).toList();
  }

  /*
   void _toggleVisibility(ObjectStatus status, bool isVisible) {
    setState(() {
      visibilityStatus[status] = isVisible;
    });
  }
  */

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
      child: controller.obx(
        (state) {
          if (state == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
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
                        items: state.keys
                            .map(
                              (sprint) => DropdownMenuItem(
                                value: sprint,
                                child: BaseLabel(text: sprint.name ?? ''),
                              ),
                            )
                            .toList(),
                        onChanged: controller.onChangeSprintSelected,
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
                    maxWidth: Helper.screenWidth() * 0.9,
                    minWidth: Helper.screenWidth() * 0.9,
                  ),
                  child: DragAndDropLists(
                    listWidth: 200,
                    axis: Axis.horizontal,
                    disableScrolling: false,
                    itemDivider: const Divider(thickness: 1, height: 1),
                    listDragOnLongPress: false,
                    onItemReorder: _onItemReorder,
                    onListReorder: (_, __) {},
                    children: [
                      for (var i = 0; i < _lists.length; i++)
                        if (visibilityStatus[ObjectStatus.values[i]] ?? false)
                          _lists[i],
                    ],
                    // itemDraggingWidth: 200,
                    listPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    listDecoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        onLoading: const Center(child: CircularProgressIndicator()),
        onError: (error) => Center(
          child: Text(
            error ?? '',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      final movedItem = _lists[oldListIndex].children.removeAt(oldItemIndex);
      _lists[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  Widget _card(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
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
                fontSize: 18.0,
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
          ],
        ),
      ),
    );
  }
}

class _KanbanBoard2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppFlowyBoardConfig(
      groupBackgroundColor: HexColor.fromHex('#F7F8FC'),
      stretchGroupHeight: false,
      groupMargin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      groupBodyPadding: const EdgeInsets.symmetric(horizontal: 8),
    );

    final KanbanController controller = Get.find<KanbanController>();

    return AppFlowyBoard(
      controller: controller.kanbanController,
      cardBuilder: (context, group, groupItem) => AppFlowyGroupCard(
        key: ValueKey(groupItem.id),
        child: _buildCard(groupItem),
      ),
      boardScrollController: controller.boardScrollController,
      footerBuilder: (context, columnData) => AppFlowyGroupFooter(
        icon: const Icon(Icons.add, size: 20),
        title: const Text('New'),
        height: 50,
        margin: config.groupBodyPadding,
        // onAddButtonClick: () => controller.boardScrollController.scrollToBottom(columnData.id),
      ),
      headerBuilder: (context, columnData) => AppFlowyGroupHeader(
        icon: const Icon(Icons.lightbulb_circle),
        title: SizedBox(
          width: 130,
          child: Text(columnData.headerData.groupName),
        ),
        height: 50,
        margin: config.groupBodyPadding,
      ),
      groupConstraints: const BoxConstraints.tightFor(width: 300),
      config: config,
    );
  }
}

class RichTextCard extends StatefulWidget {
  final RichTextItem item;

  const RichTextCard({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  State<RichTextCard> createState() => _RichTextCardState();
}

class _RichTextCardState extends State<RichTextCard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Text(
              widget.item.subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

class TextItem extends AppFlowyGroupItem {
  final String s;

  TextItem(this.s);

  @override
  String get id => s;
}

class RichTextItem extends AppFlowyGroupItem {
  final String title;
  final String subtitle;

  RichTextItem({required this.title, required this.subtitle});

  @override
  String get id => title;
}

Widget _buildCard(AppFlowyGroupItem item) {
  if (item is TextItem) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Text(item.s),
      ),
    );
  }

  if (item is RichTextItem) {
    return RichTextCard(item: item);
  }

  throw UnimplementedError();
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
