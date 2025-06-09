


import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String category;

  @HiveField(2)
  String people;

  @HiveField(3)
  String priority;

  @HiveField(4)
  String description;

  @HiveField(5)
  bool status;

  @HiveField(6)
  DateTime? reminder;

  Task({
    required this.title,
    required this.category,
    required this.people,
    required this.priority,
    required this.description,
    required this.status,
    required this.reminder,
  });
}
