import 'package:flutter/material.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/mvc/controllers/checklist_controller.dart';
import 'checklist_tile.dart';

Widget buildTasksList(ChecklistController controller) {
  return Column(
    children: [
      Expanded(
        child: RefreshIndicator(
          onRefresh: () => controller.loadItems(),
          color: AppColors.refreshIndicatorColor,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return ChecklistTile(
                item: item,
                controller: controller,
                index: index,
              );
            },
          ),
        ),
      ),
    ],
  );
}
