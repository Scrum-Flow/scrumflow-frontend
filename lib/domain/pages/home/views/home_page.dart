import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/widgets/page_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<HomePageController>(HomePageController());

    return Scaffold(
      body: PageBuilder(
        minimumInsets: EdgeInsets.zero,
        webPage: BodyWeb(),
        mobilePage: BodyMobile(),
      ),
    );
  }
}
