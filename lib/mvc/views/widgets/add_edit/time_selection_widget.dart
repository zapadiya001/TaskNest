import 'package:flutter/material.dart';
import 'package:todoapp/constants/constants.dart';

class TimeSelectionWidget extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay?) onTimeChanged;

  const TimeSelectionWidget({
    Key? key,
    required this.selectedTime,
    required this.onTimeChanged,
  }) : super(key: key);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.time,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor!),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: AppColors.iconColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : AppStrings.selectTime,
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedTime != null
                          ? AppColors.primaryText
                          : AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}