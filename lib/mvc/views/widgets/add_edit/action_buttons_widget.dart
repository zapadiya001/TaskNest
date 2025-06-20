import 'package:flutter/material.dart';
import 'package:todoapp/constants/app_colors.dart';
import 'package:todoapp/constants/app_strings.dart';

class ActionButtonsWidget extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const ActionButtonsWidget({
    Key? key,
    required this.isEditing,
    required this.onCancel,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: AppColors.borderColor),
              ),
              child: Text(
                AppStrings.cancel,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.tertiaryText,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.elevatedButtonBackground,
                foregroundColor: AppColors.elevatedButtonForeground,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                isEditing ? AppStrings.saveChanges : AppStrings.addTask,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}