class ChecklistItem {
  int? id;
  String title;
  bool isCompleted;
  DateTime createdAt;
  DateTime? dueDate;
  TaskCategory category;

  ChecklistItem({
    this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
    this.dueDate,
    this.category = TaskCategory.DEFAULT,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'category': taskCategoryToString(category),
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'])
          : null,
      category: map['category'] != null
          ? taskCategoryFromString(map['category'])
          : TaskCategory.DEFAULT,
    );
  }
}

enum TaskCategory { DEFAULT, WISHLIST, SHOPPING, WORK, PERSONAL }

TaskCategory taskCategoryFromString(String category) {
  return TaskCategory.values.firstWhere(
        (e) => e.name == category,
    orElse: () => TaskCategory.DEFAULT,
  );
}

String taskCategoryToString(TaskCategory category) {
  return category.name;
}

