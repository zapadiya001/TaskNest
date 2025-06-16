// views/checklist_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checklist_controller.dart';
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
      body: Column(
        children: [
          // Progress bar section
          _buildProgressSection(controller),
          // Main content area
          Expanded(
            child: _buildBody(controller),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar(ChecklistController controller) {
    return AppBar(
      title: Text('My Checklist'),
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

  Widget _buildProgressSection(ChecklistController controller) {
    return Obx(() {
      // Only show progress bar when there are tasks
      if (controller.items.isEmpty || controller.isLoading.value) {
        return SizedBox.shrink();
      }

      final completedCount = _getCompletedCount(controller);
      final totalCount = controller.items.length;
      final progressPercentage = (completedCount / totalCount);
      final progressText = '${(progressPercentage * 100).toInt()}%';

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress text and percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  progressText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Progress bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(progressPercentage),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 8),

            // Task count info
            Text(
              '$completedCount of $totalCount tasks completed',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBody(ChecklistController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      if (controller.items.isEmpty) {
        return EmptyStateWidget();
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

  // Helper method to get progress bar color based on completion percentage
  Color _getProgressColor(double progress) {
    if (progress >= 0.8) {
      return Colors.green;  // 80% or more - Green
    } else if (progress >= 0.5) {
      return Colors.orange; // 50-79% - Orange
    } else {
      return Colors.red;    // Less than 50% - Red
    }
  }
}