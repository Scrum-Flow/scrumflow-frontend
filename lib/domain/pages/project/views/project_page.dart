import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/project/projects.dart';
import 'package:scrumflow/models/project.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/page_builder.dart';
import 'package:scrumflow/widgets/search_field.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    ProjectPageController controller = Get.put<ProjectPageController>(ProjectPageController());

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            SearchField(
              onFieldSubmitted: controller.filterSubmitted,
              onClear: controller.filterSubmitted,
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Row(
                        children: [
                          const Expanded(
                            child: BaseLabel(
                              text: 'Projetos',
                              fontSize: fsVeryBig,
                              fontWeight: fwMedium,
                            ),
                          ),
                          PageBuilder(
                            minimumInsets: EdgeInsets.zero,
                            webPage: SizedBox(
                              width: 200,
                              child: BaseButton(
                                title: 'Criar Projeto',
                                onPressed: () => Routes.goTo(context, ProjectFormPage()),
                              ),
                            ),
                            mobilePage: IconButton(
                              tooltip: 'Criar Projeto',
                              onPressed: () => Routes.goTo(context, ProjectFormPage()),
                              icon: Icon(Icons.add_card_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ProjectList(),
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
    Get.delete<ProjectPageController>();
    super.dispose();
  }
}

class _ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProjectPageController controller = Get.find<ProjectPageController>();

    return Obx(
      () => Expanded(
        child: BaseGrid(
          onRefresh: () => controller.fetchProjects(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24).add(const EdgeInsets.only(bottom: 12)),
          pageState: controller.projectListState.value,
          items: controller.values,
          itemBuilder: (context, item) => ProjectCard(item),
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard(this.project, {super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    ProjectPageController controller = Get.find<ProjectPageController>();

    var projectPercent = controller.getProjectPercent(project);

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
              decoration: BoxDecoration(color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: BaseLabel(
                text: project.toString(),
                color: Colors.black,
                fontWeight: fwBold,
              ),
            ),
            const SizedBox(height: 8),
            BaseLabel(
              text: (project.description != null && project.description!.isNotEmpty ? project.description : 'n/d') ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              color: Colors.black,
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BaseLabel(text: Helper.formatPercent(projectPercent)),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 8,
                  value: projectPercent,
                  color: Colors.blue[300],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.mode_edit_rounded),
                  tooltip: 'Editar',
                  onPressed: () => controller.fetchProjectData(project),
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
                      title: BaseLabel(text: 'Realmente deseja excluir este projeto?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: BaseLabel(text: 'Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller.deleteProject(project);
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
