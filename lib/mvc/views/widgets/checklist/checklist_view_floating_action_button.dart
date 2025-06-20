import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/mvc/views/screens/add_edit_task_view.dart';

class ChecklistViewFloatingActionButton extends StatelessWidget {
  const ChecklistViewFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {

    void navigateToAddTask() {
      Get.to(
            () => AddEditTaskView(),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 300),
      );
    }

    return FloatingActionButton(onPressed: (){
      navigateToAddTask();
    }, child: Icon(Icons.add),backgroundColor: AppColors.primaryBlue,foregroundColor: AppColors.white,);
  }
}
