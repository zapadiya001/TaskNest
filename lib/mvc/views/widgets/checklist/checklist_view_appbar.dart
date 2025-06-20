import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/mvc/controllers/checklist_controller.dart';
import 'package:todoapp/mvc/views/widgets/checklist/checklist_view_selection_dropdown.dart';

PreferredSizeWidget buildAppBar(ChecklistController controller) {
  return AppBar(
    title: Obx(
      () => SectionDropdown(
        selectedSection: controller.category, // Current selected category
        onSectionChanged: (String newSection) {
          controller.changeCategory(newSection); // Handle category change
        },
      ),
    ),
    backgroundColor: AppColors.appBarBackground,
    foregroundColor: AppColors.appBarForeground,
    elevation: 0,
    actions: [
      Obx(
        () => controller.items.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${getCompletedCount(controller)}/${controller.items.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ),
    ],
  );
}

int getCompletedCount(ChecklistController controller) {
  return controller.items.where((item) => item.isCompleted).length;
}
