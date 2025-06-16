// controllers/checklist_controller.dart
import 'package:get/get.dart';
import '../../services/database_services.dart';
import '../models/checklist_item.dart';

class ChecklistController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  var items = <ChecklistItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      isLoading.value = true;
      final loadedItems = await _databaseService.getAllItems();
      items.value = loadedItems;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addItem(String title) async {
    if (title.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a valid title');
      return;
    }

    try {
      final newItem = ChecklistItem(title: title.trim());
      final id = await _databaseService.insertItem(newItem);
      newItem.id = id;
      items.insert(0, newItem);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item: $e');
      rethrow;
    }
  }

  Future<void> updateItem(ChecklistItem item) async {
    try {
      await _databaseService.updateItem(item);
      final index = items.indexWhere((element) => element.id == item.id);
      if (index != -1) {
        items[index] = item;
        items.refresh();
      }
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
      );

      await _databaseService.updateItem(updatedItem);

      final index = items.indexWhere((element) => element.id == item.id);
      if (index != -1) {
        items[index] = updatedItem;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
    }
  }

  Future<void> deleteItem(ChecklistItem item) async {
    try {
      await _databaseService.deleteItem(item.id!);
      items.removeWhere((element) => element.id == item.id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete item: $e');
      rethrow;
    }
  }

  Future<void> editItem(ChecklistItem item, String newTitle) async {
    if (newTitle.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a valid title');
      return;
    }

    // Check if title actually changed
    if (item.title == newTitle.trim()) {
      // Title didn't change, just return without showing error
      return;
    }

    try {
      // Create updated item
      final updatedItem = ChecklistItem(
        id: item.id,
        title: newTitle.trim(),
        isCompleted: item.isCompleted,
        createdAt: item.createdAt,
      );

      await _databaseService.updateItem(updatedItem);

      final index = items.indexWhere((element) => element.id == item.id);
      if (index != -1) {
        items[index] = updatedItem;
      }

    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
      rethrow;
    }
  }
}