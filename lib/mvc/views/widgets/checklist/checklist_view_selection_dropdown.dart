import 'package:flutter/material.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/mvc/models/checklist_item.dart';

class SectionDropdown extends StatelessWidget {
  final String selectedSection;
  final Function(String) onSectionChanged;

  const SectionDropdown({
    Key? key,
    required this.selectedSection,
    required this.onSectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedSection,
      icon: Icon(Icons.keyboard_arrow_down, color: AppColors.white),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600),
      underline: SizedBox(),
      dropdownColor: AppColors.appBarDropdownBackground,
      onChanged: (String? newValue) {
        if (newValue != null) {
          onSectionChanged(newValue);
        }
      },
      items: _getDropdownItems(),
    );
  }

  List<DropdownMenuItem<String>> _getDropdownItems() {
    final categories = TaskCategory.values;

    return categories.map<DropdownMenuItem<String>>((TaskCategory category) {
      String displayName = _getCategoryDisplayName(category);
      String value = taskCategoryToString(category);

      return DropdownMenuItem<String>(
        value: value,
        child: Row(
          children: [
            Icon(
              _getCategoryIcon(category),
              color: AppColors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              displayName,
              style: TextStyle(color: AppColors.white),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _getCategoryDisplayName(TaskCategory category) {
    switch (category) {
      case TaskCategory.DEFAULT:
        return AppStrings.allTasks;
      case TaskCategory.PERSONAL:
        return AppStrings.personal;
      case TaskCategory.WISHLIST:
        return AppStrings.wishlist;
      case TaskCategory.WORK:
        return AppStrings.work;
      case TaskCategory.SHOPPING:
        return AppStrings.shopping;
    }
  }

  IconData _getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.DEFAULT:
        return Icons.all_inclusive;
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
}