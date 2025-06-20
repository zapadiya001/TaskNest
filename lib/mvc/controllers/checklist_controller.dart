// controllers/checklist_controller.dart
import 'package:get/get.dart';
import 'package:todoapp/mvc/models/checklist_item.dart';
import 'package:todoapp/services/database_services.dart';
import 'package:todoapp/services/notification_service.dart';


class ChecklistController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();

  var items = <ChecklistItem>[].obs;
  var allItems = <ChecklistItem>[].obs;
  var isLoading = false.obs;
  var selectedCategory = TaskCategory.DEFAULT.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
    loadItems();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
  }

  // getter method for category
  String get category => taskCategoryToString(selectedCategory.value);

  //region filter method

  // ===========================================================
  // = Section: Method to filter items based on category =
  // ===========================================================

  void _filterItemsByCategory() {
    if (selectedCategory.value == TaskCategory.DEFAULT) {
      items.value = List.from(allItems);
    } else {
      items.value = allItems.where((item) => item.category == selectedCategory.value).toList();
    }
  }
  //endregion

  //region read method

  // ===========================================================
  // = Section: Method that retrieve all items =
  // ===========================================================

  Future<void> loadItems() async {
    try {
      isLoading.value = true;
      final loadedItems = await _databaseService.getAllItems();
      allItems.value = loadedItems;
      _filterItemsByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //endregion

  //region category modification methods
  void changeCategory(String categoryString) {
    selectedCategory.value = taskCategoryFromString(categoryString);
    _filterItemsByCategory();
  }
  //endregion

  //region add method

  // ===========================================================
  // = Section: Method to add items in the local database =
  // ===========================================================

  Future<void> addItem({
    required String title,
    TaskCategory? category,
    DateTime? dueDate,
  }) async {

    if (title.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a valid title');
      return;
    }

    try {
      final newItem = ChecklistItem(
        title: title.trim(),
        category: category ?? selectedCategory.value,
        dueDate: dueDate,
      );

      final id = await _databaseService.insertItem(newItem);
      newItem.id = id;

      // Schedule notification if due date is set
      if (dueDate != null && dueDate.isAfter(DateTime.now())) {
        await _notificationService.scheduleTaskReminder(
          id: id,
          title: title.trim(),
          scheduledDate: dueDate,
        );
      }

      allItems.insert(0, newItem);
      _filterItemsByCategory();

      Get.snackbar(
        'Success',
        dueDate != null
            ? 'Task added with reminder set!'
            : 'Task added successfully!',
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        colorText: Get.theme.colorScheme.primary,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item: $e');
      rethrow;
    }
  }
  //endregion

  //region update item methods

  // ===========================================================
  // = Section: Helper method to modify item =
  // ===========================================================

  Future<void> updateItem(ChecklistItem item) async {
    try {
      await _databaseService.updateItem(item);

      // Update notification if due date exists
      if (item.id != null) {
        await _notificationService.cancelNotification(item.id!);
        if (item.dueDate != null && item.dueDate!.isAfter(DateTime.now()) && !item.isCompleted) {
          await _notificationService.scheduleTaskReminder(
            id: item.id!,
            title: item.title,
            scheduledDate: item.dueDate!,
          );
        }
      }

      final allIndex = allItems.indexWhere((element) => element.id == item.id);
      if (allIndex != -1) {
        allItems[allIndex] = item;
      }

      _filterItemsByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
      rethrow;
    }
  }

  // ===========================================================
  // = Section: edit item method =
  // ===========================================================

  Future<void> editItem(
      ChecklistItem item,
      String newTitle, {
        TaskCategory? newCategory,
        DateTime? newDueDate,
      }) async {
    if (newTitle.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a valid title');
      return;
    }

    final updatedItem = ChecklistItem(
      id: item.id,
      title: newTitle.trim(),
      isCompleted: item.isCompleted,
      createdAt: item.createdAt,
      category: newCategory ?? item.category,
      dueDate: newDueDate,
    );

    try {
      await _databaseService.updateItem(updatedItem);

      // Update notification
      if (item.id != null) {
        await _notificationService.cancelNotification(item.id!);
        if (newDueDate != null && newDueDate.isAfter(DateTime.now()) && !updatedItem.isCompleted) {
          await _notificationService.scheduleTaskReminder(
            id: item.id!,
            title: newTitle.trim(),
            scheduledDate: newDueDate,
          );
        }
      }

      final allIndex = allItems.indexWhere((element) => element.id == item.id);
      if (allIndex != -1) {
        allItems[allIndex] = updatedItem;
      }

      _filterItemsByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
      rethrow;
    }
  }

  // ===========================================================
  // = Section: item completion toggle method =
  // ===========================================================

  Future<void> toggleItemCompletion(ChecklistItem item) async {
    try {
      final updatedItem = ChecklistItem(
        id: item.id,
        title: item.title,
        isCompleted: !item.isCompleted,
        createdAt: item.createdAt,
        dueDate: item.dueDate,
        category: item.category,
      );

      await _databaseService.updateItem(updatedItem);

      // Cancel notification if task is completed
      if (item.id != null && updatedItem.isCompleted) {
        await _notificationService.cancelNotification(item.id!);
      } else if (item.id != null && !updatedItem.isCompleted && item.dueDate != null && item.dueDate!.isAfter(DateTime.now())) {
        // Reschedule notification if task is uncompleted and has future due date
        await _notificationService.scheduleTaskReminder(
          id: item.id!,
          title: item.title,
          scheduledDate: item.dueDate!,
        );
      }

      final allIndex = allItems.indexWhere((element) => element.id == item.id);
      if (allIndex != -1) {
        allItems[allIndex] = updatedItem;
      }

      _filterItemsByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
    }
  }

  //endregion

  //region delete method

  // ===========================================================
  // = Section: Delete method =
  // ===========================================================

  Future<void> deleteItem(ChecklistItem item) async {
    try {
      await _databaseService.deleteItem(item.id!);

      // Cancel notification
      if (item.id != null) {
        await _notificationService.cancelNotification(item.id!);
      }

      allItems.removeWhere((element) => element.id == item.id);
      _filterItemsByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete item: $e');
      rethrow;
    }
  }
  //endregion

  //region helper methods for category

  // ===========================================================
  // = Section: Method to retrieve the category name=
  // ===========================================================

  String getCategoryDisplayName(TaskCategory category) {
    switch (category) {
      case TaskCategory.DEFAULT:
        return 'All Tasks';
      case TaskCategory.PERSONAL:
        return 'Personal';
      case TaskCategory.WISHLIST:
        return 'Wishlist';
      case TaskCategory.WORK:
        return 'Work';
      case TaskCategory.SHOPPING:
        return 'Shopping';
    }
  }

  // ===========================================================
  // = Section: Method to retrieve all categories =
  // ===========================================================

  List<TaskCategory> getAllCategories() {
    return TaskCategory.values;
  }
  //endregion
}