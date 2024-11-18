import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/base_label.dart';
import 'package:scrumflow/domain/pages/kanban/controllers/kanban_controller.dart';
import 'package:scrumflow/models/models.dart';
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
        title: const BaseLabel(text: 'Kanban', fontSize: fsVeryBig, fontWeight: fwMedium),
      ),
      body: _Body(),
    );
  }
}

class _Body extends GetView<KanbanController> {
  @override
  Widget build(BuildContext context) {
    final KanbanController controller = Get.find<KanbanController>();

    return Container(
      child: controller.obx(
        (state) {
          if (state == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              DropdownButtonFormField<SprintDetails>(
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
              Expanded(child: _KanbanBoard()),
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
}

class _KanbanBoard extends StatelessWidget {
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
