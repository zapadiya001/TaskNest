// widgets/checklist_tile.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checklist_controller.dart';
import '../models/checklist_item.dart';
import 'add_edit_task_view.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: item.isCompleted ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: item.isCompleted
                ? LinearGradient(
              colors: [Colors.green.withOpacity(0.05), Colors.green.withOpacity(0.02)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
                : null,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: _buildCustomCheckbox(),
            title: _buildTitle(),
            subtitle: _buildSubtitle(),
            trailing: _buildActionButtons(),
            onTap: () => controller.toggleItemCompletion(item),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomCheckbox() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: item.isCompleted ? Colors.green : Colors.grey[400]!,
          width: 2,
        ),
        color: item.isCompleted ? Colors.green : Colors.transparent,
      ),
      child: item.isCompleted
          ? Icon(
        Icons.check,
        color: Colors.white,
        size: 16,
      )
          : null,
    );
  }

  Widget _buildTitle() {
    return Text(
      item.title,
      style: TextStyle(
        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
        color: item.isCompleted ? Colors.grey[500] : Colors.grey[800],
        fontSize: 16,
        fontWeight: FontWeight.w500,
        decorationColor: Colors.grey[400],
        decorationThickness: 2,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 14,
            color: Colors.grey[400],
          ),
          SizedBox(width: 4),
          Text(
            _formatDate(item.createdAt),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.edit_outlined, color: Colors.blue[600], size: 20),
            onPressed: () => _navigateToEditTask(),
            tooltip: 'Edit task',
          ),
        ),
        SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[600], size: 20),
            onPressed: () => _showDeleteDialog(),
            tooltip: 'Delete task',
          ),
        ),
      ],
    );
  }

  void _navigateToEditTask() {
    Get.to(() => AddEditTaskView(taskToEdit: item));
  }

  void _showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete, color: Colors.red, size: 20),
            ),
            SizedBox(width: 12),
            Text('Delete Task'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete this task?'),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${item.title}"',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(closeOverlays: true),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => _handleDelete(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  void _handleDelete() async {
    try {
      Get.back(closeOverlays: true);

      await controller.deleteItem(item);

      Get.snackbar(
        'Success',
        'Task deleted successfully',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green[700],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );

    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to delete task: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red[700],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}