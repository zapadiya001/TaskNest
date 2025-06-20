import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/mvc/controllers/checklist_controller.dart';
import 'package:todoapp/mvc/models/checklist_item.dart';
import 'package:todoapp/mvc/views/screens/add_edit_task_view.dart';


Widget buildEmptyState(ChecklistController controller) {
  return Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            controller.selectedCategory.value == TaskCategory.DEFAULT
                ? AppStrings.noTasksYet
                : 'No ${controller.getCategoryDisplayName(controller.selectedCategory.value).toLowerCase()} tasks yet!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.tertiaryText,
            ),
          ),
          SizedBox(height: 8),
          Text(
            AppStrings.addFirstTask,
            style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => navigateToAddTask(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.add),
            label: Text(AppStrings.addTask),
          ),
        ],
      ),
    ),
  );
}

void navigateToAddTask() {
  Get.to(
    () => AddEditTaskView(),
    transition: Transition.rightToLeft,
    duration: Duration(milliseconds: 300),
  );
}
