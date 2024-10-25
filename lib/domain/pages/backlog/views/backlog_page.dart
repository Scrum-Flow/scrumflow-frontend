import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/backlog/backlog.dart';
import 'package:scrumflow/domain/pages/feature/views/feature_form_page.dart';
import 'package:scrumflow/models/models.dart';
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
                            onPressed: () async => await controller.refresh(),
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
    BacklogPageController controller = Get.find<BacklogPageController>();

    return Obx(() => controller.featuresWithoutSprintState.value.status ==
            PageStatus.loading
        ? const CircularProgressIndicator()
        : Column(
            children: [
              linhaDivisoria(),
              ExpansionTile(
                  title: const Text(
                    'Funcionalidades sem sprint',
                    textAlign: TextAlign.center,
                  ),
                  children: controller.featuresWithoutSprint.toList().isEmpty
                      ? [const Text("Nenhuma funcionalidade sem sprint")]
                      : controller.featuresWithoutSprint
                          .map((feature) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: FeatureRow(feature: feature)))
                          .toList()),
              linhaDivisoria(),
            ],
          ));
  }

  Widget linhaDivisoria() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.black38,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class FeatureRow extends StatefulWidget {
  const FeatureRow({Key? key, required this.feature}) : super(key: key);

  final Feature feature;

  @override
  _FeatureRowState createState() => _FeatureRowState();
}

class _FeatureRowState extends State<FeatureRow> {
  BacklogPageController controller = Get.find<BacklogPageController>();

  @override
  Widget build(BuildContext context) {
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
            Expanded(flex: 3, child: Text(widget.feature.name ?? "NOME AQ")),
            Expanded(
                flex: 6, child: Text(widget.feature.description ?? "DESC AQ")),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar',
                      onPressed: () {
                        Get.to(FeatureFormPage(
                          feature: widget.feature,
                          projectId: 1,
                        ));
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
                              text:
                                  'Realmente deseja excluir esta funcionalidade?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: BaseLabel(text: 'Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.deleteFeature(widget.feature);
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
