// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mvc/views/checklist_view.dart';
import 'mvc/controllers/checklist_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Checklist App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChecklistView(),
    );
  }
}