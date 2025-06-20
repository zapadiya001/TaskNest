import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:todoapp/mvc/controllers/checklist_controller.dart';
import 'checklist_view_listview.dart';
import 'checklist_view_empty_view.dart';

Widget buildBody(ChecklistController controller) {
  return Obx(() {
    if (controller.items.isEmpty) {
      return buildEmptyState(controller);
    }

    return buildTasksList(controller);
  });
}