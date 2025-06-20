import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/mvc/controllers/checklist_controller.dart';
import 'package:todoapp/mvc/views/widgets/widgets.dart';


class ChecklistView extends StatelessWidget {
  const ChecklistView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing controller
    final ChecklistController controller = Get.put(ChecklistController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(controller),
      body: buildBody(controller),
      floatingActionButton: ChecklistViewFloatingActionButton(),
    );
  }
}
