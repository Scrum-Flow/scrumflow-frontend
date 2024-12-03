import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scrumflow/domain/pages/kanban/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/utils/enums/enum_status.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:universal_html/html.dart' as html;

class ReportController extends GetxController {
  ReportController(this.projectId);

  int projectId;
  late ProjectDetails projectDetails;
  late final fontRegular;
  late final fontBold;

  Rx<PageState> pageState = PageState.none().obs;

  @override
  Future<void> onInit() async {
    pageState.value = PageState.loading();

    await fetchProjectDetails();

    await loadFonts();

    super.onInit();
    pageState.value = PageState.none();
  }

  FutureOr<void> fetchProjectDetails() async {
    try {
      projectDetails = await KanbanService.projectDetails(projectId);
    } on DioException catch (e) {
      debugPrint(e.toString());
      pageState.value = PageState.error();
    } catch (e) {
      debugPrint(e.toString());
      pageState.value = PageState.error();
    }
  }

  List<pw.Widget> _buildSprintDetails() {
    return projectDetails.sprints?.map((sprint) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Sprint: ${sprint.name ?? "Sem nome"}',
                style: pw.TextStyle(fontSize: 18, font: fontBold),
              ),
              pw.Text('Descrição: ${sprint.description ?? "Não especificado"}',
                  style: pw.TextStyle(font: fontRegular)),
              pw.SizedBox(height: 10),
              ..._buildFeatureDetails(sprint.features),
            ],
          );
        }).toList() ??
        [];
  }

  List<pw.Widget> _buildFeatureDetails(List<FeatureDetails>? features) {
    return features?.map((feature) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '  - Funcionalidade: ${feature.name ?? "Sem nome"}',
                style: pw.TextStyle(fontSize: 16, font: fontBold),
              ),
              pw.Text(
                  '    Descrição: ${feature.description ?? "Não especificado"}',
                  style: pw.TextStyle(font: fontRegular)),
              pw.SizedBox(height: 5),
              ..._buildTaskDetails(feature.tasks),
            ],
          );
        }).toList() ??
        [];
  }

  List<pw.Widget> _buildTaskDetails(List<Task>? tasks) {
    return tasks?.map((task) {
          return pw.Text(
              '      * Tarefa: ${task.name ?? "Sem nome"} - ${ObjectStatus.getOsToString(task.status!)}',
              style: pw.TextStyle(font: fontRegular));
        }).toList() ??
        [];
  }

  Future<void> loadFonts() async {
    if (kIsWeb) {
      fontRegular =
          pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
      fontBold =
          pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
    } else {
      fontRegular = pw.Font.ttf((await File('assets/fonts/Roboto-Regular.ttf')
          .readAsBytes()) as ByteData);
      fontBold = pw.Font.ttf((await File('assets/fonts/Roboto-Bold.ttf')
          .readAsBytes()) as ByteData);
    }
  }

  Future<File> generatePdf() async {
    final pdfBytes = await generatePdfBytes();

    final output = await getTemporaryDirectory();

    final file = File("${output.path}/project_report.pdf");
    await file.writeAsBytes(pdfBytes);

    return file;
  }

  Future<Uint8List> generatePdfBytes() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'Relatório do Projeto',
            style: pw.TextStyle(fontSize: 24, font: fontBold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Nome: ${projectDetails.name ?? "Não especificado"}',
            style: pw.TextStyle(font: fontRegular),
          ),
          pw.Text(
            'Descrição: ${projectDetails.description ?? "Não especificado"}',
            style: pw.TextStyle(font: fontRegular),
          ),
          pw.SizedBox(height: 10),
          ..._buildSprintDetails(),
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> downloadPdf(BuildContext context) async {
    try {
      final pdfBytes = await generatePdfBytes();

      if (kIsWeb) {
        final blob = html.Blob([pdfBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = 'relatorio.pdf'
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final output = await getTemporaryDirectory();
        final file = File("${output.path}/project_report.pdf");
        await file.writeAsBytes(pdfBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF salvo em: ${file.path}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar o arquivo PDF: $e")),
      );
    }
  }
}
