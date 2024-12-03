import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/report/controllers/report_controller.dart';
import 'package:scrumflow/utils/page_state.dart';
import 'package:universal_html/html.dart' as html;

class ReportPage extends StatelessWidget {
  final int projectId;

  const ReportPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.put(ReportController(projectId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Relatório do Projeto"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "Baixar PDF",
            onPressed: () async => await controller.downloadPdf(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.pageState.value.status == PageStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (kIsWeb) {
          return Center(
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final pdfBytes = await controller.generatePdfBytes();

                  final blob = html.Blob([pdfBytes], 'application/pdf');

                  final url = html.Url.createObjectUrlFromBlob(blob);

                  html.window.open(url, "_blank");

                  html.Url.revokeObjectUrl(url);
                } catch (e) {
                  debugPrint('Erro ao visualizar o PDF: $e');
                }
              },
              child: const Text("Visualizar PDF"),
            ),
          );
        } else {
          return FutureBuilder<File>(
            future: controller.generatePdf(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                debugPrint(snapshot.error.toString());
                return const Center(child: Text("Erro ao carregar o PDF."));
              }
              final pdfFile = snapshot.data!;
              return PDFView(filePath: pdfFile.path);
            },
          );
        }
      }),
    );
  }
}
