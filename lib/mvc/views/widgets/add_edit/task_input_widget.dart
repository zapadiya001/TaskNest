import 'package:flutter/material.dart';
import 'package:todoapp/constants/constants.dart';

class TaskInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;

  const TaskInputWidget({
    Key? key,
    required this.controller,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.taskTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: AppStrings.enterTaskHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.outlinedButtonBorder!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.focusedBorderColor),
            ),
            filled: true,
            fillColor: AppColors.white,
            prefixIcon: Icon(Icons.task_alt, color: AppColors.iconColor),
          ),
          style: const TextStyle(fontSize: 16),
          autofocus: autofocus,
        ),
      ],
    );
  }
}
