import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/mvc/models/checklist_item.dart';
import 'package:todoapp/mvc/controllers/checklist_controller.dart';
import 'package:todoapp/mvc/views/screens/add_edit_task_view.dart';
import 'package:todoapp/constants/constants.dart';


class ChecklistTile extends StatelessWidget {
  final ChecklistItem item;
  final ChecklistController controller;
  final int index;

  const ChecklistTile({
    Key? key,
    required this.item,
    required this.controller,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isCompleted ? AppColors.completedTaskBackground : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: item.isCompleted ? AppColors.completedTaskShadow : AppColors.shadowColor,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Checkbox(
          value: item.isCompleted,
          onChanged: (bool? value) => controller.toggleItemCompletion(item),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
             color: item.isCompleted ? AppColors.completedTaskText : AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(
                Icons.category,
                size: 14,
                color: item.isCompleted ? AppColors.completedTaskIcon : AppColors.iconColor,
              ),
              SizedBox(width: 4),
              Text(
                getCategoryName(item),
                style: TextStyle(
                  color: item.isCompleted? AppColors.completedTaskText : AppColors.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        onTap: () => _navigateToEditTask(),
      ),
    );
  }

  void _navigateToEditTask() {
    Get.to(() => AddEditTaskView(task: item));
  }

  String getCategoryName(ChecklistItem item) {
    final categoryName = controller.getCategoryDisplayName(item.category);
    return categoryName == 'All Tasks' ? 'Default' : categoryName;
  }
}