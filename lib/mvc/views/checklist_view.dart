// views/checklist_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/mvc/views/section_dropdown.dart';
import '../controllers/checklist_controller.dart';
import '../models/checklist_item.dart';
import 'add_edit_task_view.dart';
import 'checklist_tile.dart';
import 'empty_state_widget.dart';

class ChecklistView extends StatelessWidget {
  const ChecklistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initializing controller
    final ChecklistController controller = Get.put(ChecklistController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(controller),
      body: _buildBody(controller),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar(ChecklistController controller) {
    return AppBar(
      title: Obx(() => SectionDropdown(
        selectedSection: controller.category, // Current selected category
        onSectionChanged: (String newSection) {
          controller.changeCategory(newSection); // Handle category change
        },
      )),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        Obx(() => controller.items.isNotEmpty
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
                '${_getCompletedCount(controller)}/${controller.items.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
            : SizedBox.shrink()),
      ],
    );
  }

  Widget _buildBody(ChecklistController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      if (controller.items.isEmpty) {
        return _buildEmptyState(controller);
      }

      return _buildTasksList(controller);
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            'Loading your tasks...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ChecklistController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            controller.selectedCategory.value == TaskCategory.DEFAULT
                ? 'No tasks yet!'
                : 'No ${controller.getCategoryDisplayName(controller.selectedCategory.value).toLowerCase()} tasks yet!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first task to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddTask(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.add),
            label: Text('Add Task'),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(ChecklistController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.loadItems(),
      color: Colors.blue,
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
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _navigateToAddTask(),
      backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white),
      tooltip: 'Add new task',
      heroTag: 'add_task_fab',
    );
  }

  void _navigateToAddTask() {
    Get.to(
          () => AddEditTaskView(),
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: 300),
    );
  }

  int _getCompletedCount(ChecklistController controller) {
    return controller.items.where((item) => item.isCompleted).length;
  }
}