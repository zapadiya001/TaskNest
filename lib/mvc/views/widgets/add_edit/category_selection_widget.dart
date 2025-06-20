import 'package:flutter/material.dart';
import 'package:todoapp/mvc/models/checklist_item.dart';
import 'package:todoapp/utils/utils.dart';
import 'package:todoapp/constants/constants.dart';

class CategorySelectionWidget extends StatelessWidget {
  final TaskCategory selectedCategory;
  final Function(TaskCategory) onCategoryChanged;

  const CategorySelectionWidget({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.category,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor!),
          ),
          child: PopupMenuButton<TaskCategory>(
            onSelected: (TaskCategory category) {
              onCategoryChanged(category);
            },
            offset: const Offset(0, -16), // Negative offset to overlap the button
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 32, // Full width minus padding
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: Row(
              children: [
                Icon(
                  CategoryUtils.getCategoryIcon(selectedCategory),
                  color: CategoryUtils.getCategoryColor(selectedCategory),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    CategoryUtils.getCategoryName(selectedCategory),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.iconColor,
                ),
              ],
            ),
            itemBuilder: (BuildContext context) => TaskCategory.values.map((category) {
              final isSelected = selectedCategory == category;
              return PopupMenuItem<TaskCategory>(
                value: category,
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryBlue.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: CategoryUtils.getCategoryColor(category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          CategoryUtils.getCategoryIcon(category),
                          color: CategoryUtils.getCategoryColor(category),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          CategoryUtils.getCategoryName(category),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? AppColors.primaryBlue : AppColors.primaryText,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check,
                          color: AppColors.primaryBlue,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}