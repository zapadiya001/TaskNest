// utils/category_utils.dart
import 'package:flutter/material.dart';
import '../mvc/models/checklist_item.dart';


class CategoryUtils {
  static String getCategoryName(TaskCategory category) {
    switch (category) {
      case TaskCategory.DEFAULT:
        return 'Default';
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

  static IconData getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.DEFAULT:
        return Icons.task;
      case TaskCategory.PERSONAL:
        return Icons.person;
      case TaskCategory.WISHLIST:
        return Icons.favorite;
      case TaskCategory.WORK:
        return Icons.work;
      case TaskCategory.SHOPPING:
        return Icons.shopping_cart;
    }
  }

  static Color getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.DEFAULT:
        return Colors.grey;
      case TaskCategory.PERSONAL:
        return Colors.green;
      case TaskCategory.WISHLIST:
        return Colors.pink;
      case TaskCategory.WORK:
        return Colors.indigo;
      case TaskCategory.SHOPPING:
        return Colors.orange;
    }
  }
}