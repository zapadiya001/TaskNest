// controllers/checklist_controller.dart
import 'package:get/get.dart';
import '../../services/database_services.dart';
import '../models/checklist_item.dart';

class ChecklistController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  var items = <ChecklistItem>[].obs;
  var allItems = <ChecklistItem>[].obs; // Store all items
  var isLoading = false.obs;
  var selectedCategory = TaskCategory.DEFAULT.obs; // Current selected category

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  // Getter for current category as string (for dropdown)
  String get category => taskCategoryToString(selectedCategory.value);

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

  // Method to change category and filter items
  void changeCategory(String categoryString) {
    selectedCategory.value = taskCategoryFromString(categoryString);
    _filterItemsByCategory();
  }

  // Private method to filter items based on selected category
  void _filterItemsByCategory() {
    if (selectedCategory.value == TaskCategory.DEFAULT) {
      // Show all items when DEFAULT is selected
      items.value = List.from(allItems);
    } else {
      // Filter items by selected category
      items.value = allItems.where((item) => item.category == selectedCategory.value).toList();
    }
  }

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
        category: category ?? selectedCategory.value, // Use selected category as default
        dueDate: dueDate,
      );
      final id = await _databaseService.insertItem(newItem);
      newItem.id = id;

      // Add to allItems and refresh filtering
      allItems.insert(0, newItem);
      _filterItemsByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item: $e');
      rethrow;
    }
  }

  Future<void> updateItem(ChecklistItem item) async {
    try {
      await _databaseService.updateItem(item);

      // Update in allItems
      final allIndex = allItems.indexWhere((element) => element.id == item.id);
      if (allIndex != -1) {
        allItems[allIndex] = item;
      }

      // Refresh filtering
      _filterItemsByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
      rethrow;
    }
  }

  Future<void> toggleItemCompletion(ChecklistItem item) async {
    try {
      // Create a new instance to ensure reactivity
      final updatedItem = ChecklistItem(
        id: item.id,
        title: item.title,
        isCompleted: !item.isCompleted,
        createdAt: item.createdAt,
        dueDate: item.dueDate,
        category: item.category,
      );

      await _databaseService.updateItem(updatedItem);

      // Update in allItems
      final allIndex = allItems.indexWhere((element) => element.id == item.id);
      if (allIndex != -1) {
        allItems[allIndex] = updatedItem;
      }

      // Refresh filtering
      _filterItemsByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
    }
  }

  Future<void> deleteItem(ChecklistItem item) async {
    try {
      await _databaseService.deleteItem(item.id!);

      // Remove from allItems
      allItems.removeWhere((element) => element.id == item.id);

      // Refresh filtering
      _filterItemsByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete item: $e');
      rethrow;
    }
  }

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
      dueDate: newDueDate ?? item.dueDate,
    );

    try {
      await _databaseService.updateItem(updatedItem);

      // Update in allItems
      final allIndex = allItems.indexWhere((element) => element.id == item.id);
      if (allIndex != -1) {
        allItems[allIndex] = updatedItem;
      }

      // Refresh filtering
      _filterItemsByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
      rethrow;
    }
  }

  // Method to get category display name
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

  // Method to get all available categories
  List<TaskCategory> getAllCategories() {
    return TaskCategory.values;
  }
}