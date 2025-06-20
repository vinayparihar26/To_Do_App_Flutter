import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/features/model/task.dart';
import 'package:to_do_app/features/responsive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box<Task> taskBox = Hive.box<Task>('tasks');
  String? selectedTitle;
  int filterStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                PopupMenuButton(
                  onSelected: (value) {
                    setState(() {
                      filterStatus = value;
                      selectedTitle = null;
                    });
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(value: 0, child: Text('All')),
                        PopupMenuItem(value: 1, child: Text('Completed')),
                        PopupMenuItem(value: 2, child: Text('Pending')),
                      ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 0.850*getWidth(context),
                          height: 0.060*getHeight(context),
                          child: ValueListenableBuilder(
                            valueListenable: taskBox.listenable(),
                            builder: (
                              BuildContext context,
                              Box<Task> box,
                              Widget? child,
                            ) {
                              final titles =
                                  box.values
                                      .map((e) => e.title)
                                      .toSet()
                                      .toList();
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            selectedTitle == null
                                                ? const Color.fromARGB(255, 91, 162, 209)
                                                : null,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedTitle = null;
                                        });
                                      },
                                      child: const Text('All'),
                                    ),
                                  ),

                                  ...titles.map(
                                    (title) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              selectedTitle == title
                                                  ?  const Color.fromARGB(255, 91, 162, 209)
                                                  : null,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selectedTitle = title;
                                          });
                                        },
                                        child: Text(title),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: taskBox.listenable(),
                builder: (context, Box<Task> box, _) {
                  final allTasks =
                      selectedTitle == null
                          ? box.values.toList()
                          : box.values
                              .where(
                                (task) =>
                                    // selectedTitle == null ||
                                    task.title.trim().toLowerCase() ==
                                    selectedTitle!.trim().toLowerCase(),
                              )
                              .toList();

                  List<Task> filteredTasks;
                  if (filterStatus == 1) {
                    filteredTasks =
                        allTasks.where((task) => task.status == true).toList();
                  } else if (filterStatus == 2) {
                    filteredTasks =
                        allTasks.where((task) => task.status == false).toList();
                  } else {
                    filteredTasks = allTasks;
                  }

                  final tasksToShow = filteredTasks;

                  if (box.isEmpty) {
                    return Center(
                      child: Text(
                        'No tasks added!',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasksToShow.length,
                    itemBuilder: (context, index) {
                      Task task = tasksToShow[index];
                      bool status =
                          task.status is bool
                              ? task.status
                              : task.status.toString().toLowerCase() == 'true';

                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed:
                            (direction) => setState(() {
                              final taskKey = task.key;
                              taskBox.delete(taskKey);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${task.title} deleted'),
                                ),
                              );
                            }),
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            onLongPress: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder:
                              //         (_) =>
                              //             AddTask(),
                              //   ),
                              // );
                            },
                            title: Text(task.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Reminder: ${task.reminder}'),
                                Text('Priority: ${task.priority}'),
                                Text('Category: ${task.category}'),
                                Text('Description: ${task.description}'),
                                Text('People: ${task.people}'),
                                Text(
                                  'Status: ${task.status == true ? 'Completed' : 'Pending'}',
                                ),
                              ],
                            ),

                            trailing: Column(
                              children: [
                                Checkbox(
                                  value: status,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      task.status = value ?? false;
                                      task.save();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          value == true
                                              ? 'Marked "${task.title}" as completed'
                                              : 'Marked "${task.title}" as pending',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
