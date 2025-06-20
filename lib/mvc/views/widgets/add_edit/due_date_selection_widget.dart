import 'package:flutter/material.dart';
import 'package:todoapp/utils/utils.dart';
import 'package:todoapp/constants/constants.dart';

class DueDateSelectionWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onDateChanged;

  const DueDateSelectionWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.dueDate,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlinedButtonBorder!),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.iconColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateUtilss.formatDate(selectedDate!)
                        : AppStrings.selectDueDate,
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDate != null
                          ? AppColors.primaryText
                          : AppColors.secondaryText,
                    ),
                  ),
                ),
                if (selectedDate != null)
                  IconButton(
                    icon: Icon(Icons.clear, size: 20, color: AppColors.iconColor),
                    onPressed: () => onDateChanged(null),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}