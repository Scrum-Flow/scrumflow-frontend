import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/feature/feature.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/widgets/widgets.dart';

class FeaturePage extends StatefulWidget {
  const FeaturePage({super.key, required this.projectId});

  final int projectId;

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  @override
  Widget build(BuildContext context) {
    FeaturePageController featureController = Get.put<FeaturePageController>(
        FeaturePageController(projectId: widget.projectId));

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            SearchField(
              onFieldSubmitted: featureController.filterSubmitted,
              onClear: featureController.filterSubmitted,
            ),
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
                              text: 'Funcionalidades',
                              fontSize: fsVeryBig,
                              fontWeight: fwMedium,
                            ),
                          ),
                          PageBuilder(
                            minimumInsets: EdgeInsets.zero,
                            webPage: SizedBox(
                              width: 200,
                              child: BaseButton(
                                title: 'Criar Funcionalidade',
                                onPressed: () => Get.to(FeatureFormPage(
                                  projectId: 1,
                                )),
                                /*,*/
                              ),
                            ),
                            mobilePage: IconButton(
                              tooltip: 'Criar Funcionalidade',
                              onPressed: () => Get.to(FeatureFormPage(
                                projectId: 1,
                              )),
                              /*Routes.goTo(
                                  context, FeatureFormPage(projectId: 1)),*/
                              icon: Icon(Icons.add_card_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _FeatureList(),
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
    Get.delete<FeaturePageController>();
    super.dispose();
  }
}

class _FeatureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FeaturePageController controller = Get.find<FeaturePageController>();

    return Obx(
      () => Expanded(
        child: BaseGrid(
          onRefresh: () => controller.fetchFeatures(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24)
              .add(const EdgeInsets.only(bottom: 12)),
          pageState: controller.featureListState.value,
          items: controller.values,
          itemBuilder: (context, item) => FeatureCard(item),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard(this.feature, {super.key});

  final Feature feature;

  @override
  Widget build(BuildContext context) {
    FeaturePageController controller = Get.find<FeaturePageController>();

    return Card(
      shadowColor: Colors.black45,
      elevation: 2,
      color: Colors.grey[250],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: BaseLabel(
                text: feature.toString(),
                color: Colors.black,
                fontWeight: fwBold,
              ),
            ),
            const SizedBox(height: 8),
            BaseLabel(
              text: (feature.description != null &&
                          feature.description!.isNotEmpty
                      ? feature.description
                      : 'n/d') ??
                  '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              color: Colors.black,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.mode_edit_rounded),
                  tooltip: 'Editar',
                  onPressed: () => Get.to(FeatureFormPage(
                    feature: feature,
                    projectId: 1,
                  )),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                  ),
                  tooltip: 'Excluir',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: BaseLabel(
                          text: 'Realmente deseja excluir esta Funcionalidade'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: BaseLabel(text: 'Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller.deleteFeature(feature);
                          },
                          child: BaseLabel(text: 'Confirmar'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
