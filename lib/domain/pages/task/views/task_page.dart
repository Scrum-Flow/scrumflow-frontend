import 'package:flutter/material.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

import 'task_form_page.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key, required this.feature});

  final Feature feature;

  @override
  Widget build(BuildContext context) {
    //TODO : Controller da página

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
                                onPressed: () => Routes.goTo(
                                    context,
                                    TaskFormPage(
                                      feature: feature,
                                    )),
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
                    _cabecalho(),
                    _TaskList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cabecalho() {
    return const Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  flex: 8,
                  child: Text('Responsável',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 3,
                  child: Text('Pontos',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 5,
                  child: Text('Status',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 2,
                  child: Text('Editar',
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
  final List<Functionality> functionalities = [
    Functionality(
      title: 'Página de Login',
      tasks: [
        Task(
            name: 'Criar formulário de login',
            description: 'Tarefa designada para criar o formulário.',
            assignedUser: 'Gabriel F.',
            estimatePoints: 5,
            status: 'Aberta'),
        Task(
            name: 'Validações de requisições',
            description: 'Tarefa designada para validações.',
            assignedUser: 'Luis Jun.',
            estimatePoints: 7,
            status: 'Pausada'),
        Task(
            name: 'Redirecionamento',
            description: 'Tarefa designada para redirecionamento.',
            assignedUser: 'Taís Lun.',
            estimatePoints: 3,
            status: 'Fazendo'),
      ],
    ),
    Functionality(
      title: 'Página de Cadastro',
      tasks: [
        Task(
            name: 'Criar formulário de cadastro',
            description: 'Tarefa designada para criar o formulário.',
            assignedUser: 'Ana M.',
            estimatePoints: 4,
            status: 'Fazendo'),
      ],
    ),
    Functionality(
      title: 'Gestão de Projetos',
      tasks: [
        Task(
            name: 'Organizar backlog',
            description: 'Tarefa para organizar backlog.',
            assignedUser: 'José S.',
            estimatePoints: 6,
            status: 'Aberta'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: functionalities.map((functionality) {
        return ExpansionTile(
          title: Text(
            'Funcionalidade: ${functionality.title}',
            textAlign: TextAlign.center,
          ),
          children: functionality.tasks.map((task) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _task(task));
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _task(Task task) {
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
            Expanded(flex: 8, child: Text(task.assignedUser ?? "NOME AQ")),
            Expanded(flex: 3, child: Text(task.estimatePoints.toString())),
            Expanded(flex: 5, child: Text(task.status ?? "ASTATAS")),
            Expanded(
                flex: 2,
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

class Functionality {
  final String title;
  final List<Task> tasks;

  Functionality({
    required this.title,
    required this.tasks,
  });
}
