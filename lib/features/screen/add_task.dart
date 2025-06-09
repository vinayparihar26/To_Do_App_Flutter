import 'package:flutter/material.dart';
import 'package:to_do_app/features/widgets/uihelper.dart';


class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  Widget build(BuildContext context) {
    return Uihelper.addTask(context);
  }
}
