// views/add_edit_task_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checklist_controller.dart';
import '../models/checklist_item.dart';

class AddEditTaskView extends StatefulWidget {
  final ChecklistItem? taskToEdit;

  const AddEditTaskView({Key? key, this.taskToEdit}) : super(key: key);

  @override
  _AddEditTaskViewState createState() => _AddEditTaskViewState();
}

class _AddEditTaskViewState extends State<AddEditTaskView> {
  late TextEditingController _titleController;
  final ChecklistController _controller = Get.find<ChecklistController>();

  bool get isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.taskToEdit?.title ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      // KEY CHANGE 1: Set resizeToAvoidBottomInset to true
      resizeToAvoidBottomInset: true,
      body: _buildBody(),
      // KEY CHANGE 2: Remove bottomNavigationBar and integrate buttons in body
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(isEditing ? 'Edit Task' : 'Add New Task'),
      backgroundColor: isEditing ? Colors.orange : Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Get.back(closeOverlays: true),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 30),
                  _buildTaskTitleSection(),
                  SizedBox(height: 20),
                  if (isEditing) ...[
                    SizedBox(height: 30),
                    _buildTaskInfoSection(),
                  ],
                  // Add some bottom padding to ensure content is not too close to buttons
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Fixed bottom buttons that stay above keyboard
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
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
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isEditing ? Colors.orange : Colors.blue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isEditing ? Icons.edit : Icons.add_task,
              color: isEditing ? Colors.orange : Colors.blue,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Your Task' : 'Create New Task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isEditing
                      ? 'Make changes to your existing task'
                      : 'Add a new task to your checklist',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Enter your task ...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(
                Icons.task_alt,
                color: Colors.grey[400],
              ),
            ),
            style: TextStyle(fontSize: 16),
            maxLines: 2,
            minLines: 1,
            autofocus: !isEditing,
            // KEY CHANGE 3: Add text input action to show save button on keyboard
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskInfoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                'Task Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildInfoRow('Status', widget.taskToEdit!.isCompleted ? 'Completed' : 'Pending'),
          SizedBox(height: 8),
          _buildInfoRow('Created', _formatDate(widget.taskToEdit!.createdAt)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  // KEY CHANGE 4: New bottom buttons widget that stays above keyboard
  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(closeOverlays: true),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEditing ? Colors.orange : Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isEditing ? Icons.save : Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(
                    isEditing ? 'Save Changes' : 'Add Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveTask() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a task title',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red[700],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      return;
    }

    try {
      if (isEditing) {
        await _controller.editItem(widget.taskToEdit!, title);
      } else {
        await _controller.addItem(title);
      }

      // Show success message
      Get.snackbar(
        'Success',
        isEditing ? 'Task updated successfully!' : 'Task added successfully!',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green[700],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );

      Get.back(closeOverlays: true);

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to ${isEditing ? 'update' : 'add'} task: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red[700],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}