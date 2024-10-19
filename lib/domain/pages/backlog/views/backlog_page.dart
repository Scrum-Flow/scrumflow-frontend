import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/backlog/backlog.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class BacklogPage extends StatefulWidget {
  const BacklogPage({super.key, required this.projectId});

  final int projectId;

  @override
  State<BacklogPage> createState() => _BacklogPageState();
}

class _BacklogPageState extends State<BacklogPage> {
  @override
  Widget build(BuildContext context) {
    BacklogPageController controller = Get.put<BacklogPageController>(
        BacklogPageController(projectId: widget.projectId));

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
                              text: 'Backlog',
                              fontSize: fsVeryBig,
                              fontWeight: fwMedium,
                            ),
                          ),
                          PageBuilder(
                            minimumInsets: EdgeInsets.zero,
                            webPage: SizedBox(
                              width: 200,
                              child: BaseButton(
                                  title: 'Criar Sprint',
                                  onPressed: () =>
                                      Get.toNamed(Routes.sprintFormPage)),
                            ),
                            mobilePage: IconButton(
                              tooltip: 'Nova Sprint',
                              onPressed: () =>
                                  Get.toNamed(Routes.sprintFormPage),
                              icon: Icon(Icons.library_add_outlined),
                            ),
                          ),
                          15.toSizedBoxW(),
                          PageBuilder(
                            minimumInsets: EdgeInsets.zero,
                            webPage: SizedBox(
                              width: 200,
                              child: BaseButton(
                                  title: 'Criar Funcionalidade',
                                  onPressed: () =>
                                      Get.toNamed(Routes.featureFormPage)),
                            ),
                            mobilePage: IconButton(
                              tooltip: 'Nova Funcionalidade',
                              onPressed: () =>
                                  Get.toNamed(Routes.featureFormPage),
                              icon: Icon(Icons.featured_video_outlined),
                            ),
                          ),
                          15.toSizedBoxW(),
                          IconButton(
                            tooltip: 'Atualizar',
                            onPressed: () => {},
                            icon: const Icon(
                              Icons.refresh,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _BacklogList(),
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
    Get.delete<BacklogPageController>();
    super.dispose();
  }
}

class _BacklogList extends StatelessWidget {
  const _BacklogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const _FeaturesWithoutSprint(),
            20.toSizedBoxH(),
            const _FeaturesPerSprint(),
          ],
        ),
      ),
    );
  }
}

class _FeaturesPerSprint extends StatelessWidget {
  const _FeaturesPerSprint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text("Sprints e suas funcionalidades")],
    );
  }
}

class _FeaturesWithoutSprint extends StatelessWidget {
  const _FeaturesWithoutSprint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text("Funcionalidades sem Sprint")],
    );
  }
}
