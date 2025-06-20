import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/mvc/controllers/checklist_controller.dart';
import 'package:todoapp/mvc/models/checklist_item.dart';
import 'package:todoapp/mvc/views/widgets/widgets.dart';

class AddEditTaskView extends StatefulWidget {
  final ChecklistItem? task;

  const AddEditTaskView({Key? key, this.task}) : super(key: key);

  @override
  _AddEditTaskViewState createState() => _AddEditTaskViewState();
}

class _AddEditTaskViewState extends State<AddEditTaskView> {
  late TextEditingController _titleController;
  late TaskCategory _selectedCategory;
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedTime;
  final ChecklistController _controller = Get.find<ChecklistController>();

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _initializeForm() {
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _selectedCategory = widget.task?.category ?? _controller.selectedCategory.value;

    if (widget.task?.dueDate != null) {
      _selectedDueDate = widget.task!.dueDate;
      _selectedTime = TimeOfDay.fromDateTime(widget.task!.dueDate!);
    }
  }

  void _onCategoryChanged(TaskCategory category) {
    setState(() => _selectedCategory = category);
  }

  void _onDueDateChanged(DateTime? date) {
    setState(() {
      _selectedDueDate = date;
      if (date == null) _selectedTime = null;
    });
  }

  void _onTimeChanged(TimeOfDay? time) {
    setState(() => _selectedTime = time);
  }

  DateTime? _getCombinedDueDate() {
    if (_selectedDueDate == null || _selectedTime == null) return null;
    return DateTime(
      _selectedDueDate!.year,
      _selectedDueDate!.month,
      _selectedDueDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  void _saveTask() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showSnackbar('Error', AppStrings.taskTitleRequired, isError: true);
      return;
    }

    final dueDate = _getCombinedDueDate();

    try {
      if (isEditing) {
        await _controller.editItem(
          widget.task!,
          title,
          newCategory: _selectedCategory,
          newDueDate: dueDate,
        );
      } else {
        await _controller.addItem(
          title: title,
          category: _selectedCategory,
          dueDate: dueDate,
        );
      }

      _showSnackbar('Success', isEditing ? AppStrings.taskUpdated : AppStrings.taskAdded);
      Get.back(closeOverlays: true);
    } catch (_) {
      _showSnackbar('Error', 'Failed to ${isEditing ? 'update' : 'add'} task', isError: true);
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,

      backgroundColor: isError ? AppColors.errorSnackbarBackground : AppColors.successSnackbarBackground,
      colorText: isError ? AppColors.errorSnackbarText : AppColors.successSnackbarText,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(milliseconds: 1000),
      animationDuration: Duration(milliseconds: 500)
    );
  }

  void _showDeleteConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(AppStrings.areYouSure),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text(AppStrings.cancel)),
          TextButton(onPressed: _deleteTask, child: const Text(AppStrings.delete)),
        ],
      ),
    );
  }

  void _deleteTask() {
    if (widget.task != null) {
      _controller.deleteItem(widget.task!);
      Get.back(closeOverlays: true);
      _showSnackbar('Success',AppStrings.taskDeleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? '' : AppStrings.newTask),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: isEditing
            ? [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ]
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskInputWidget(
                        controller: _titleController,
                        autofocus: !isEditing,
                      ),
                      const SizedBox(height: 20),
                      CategorySelectionWidget(
                        selectedCategory: _selectedCategory,
                        onCategoryChanged: _onCategoryChanged,
                      ),
                      const SizedBox(height: 20),
                      DueDateSelectionWidget(
                        selectedDate: _selectedDueDate,
                        onDateChanged: _onDueDateChanged,
                      ),
                      if (_selectedDueDate != null) ...[
                        const SizedBox(height: 20),
                        TimeSelectionWidget(
                          selectedTime: _selectedTime,
                          onTimeChanged: _onTimeChanged,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              ActionButtonsWidget(
                isEditing: isEditing,
                onCancel: () => Get.back(),
                onSave: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
