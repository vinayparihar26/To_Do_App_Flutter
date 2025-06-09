import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/features/model/task.dart';

import 'package:to_do_app/features/responsive.dart';


class Uihelper {


  static Widget addTask(BuildContext context, {Task? task, int? index}) {
    final isEditing = task != null;
    final _formKey = GlobalKey<FormState>();
    TextEditingController titleController = TextEditingController(
      text: task?.title ?? '',
    );
    TextEditingController categoryController = TextEditingController(
      text: task?.category ?? '',
    );
    TextEditingController peopleController = TextEditingController(
      text: task?.people ?? '',
    );
    TextEditingController priorityController = TextEditingController(
      text: task?.priority ?? '',
    );
    TextEditingController descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    TextEditingController reminderController = TextEditingController(
      text: task?.reminder?.toString() ?? '',
    );
    DateTime? selectedDateTime = task?.reminder;

    Future<void> pickDateTime() async {
      DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      );
      if (date != null) {
        TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );

          reminderController.text =
              '${selectedDateTime!.toLocal()}'.split('.')[0];
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset:  true,
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title name', style: TextStyle(fontSize: 20)),
                SizedBox(height: 0.01 * getHeight(context)),
                TextFormField(
                  controller: titleController,
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'dr.appointment',
                  ),
                ),
                SizedBox(height: 0.01 * getHeight(context)),
                Text('Reminder', style: TextStyle(fontSize: 20)),
                TextFormField(
                  controller: reminderController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'select data and time',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: pickDateTime,
                ),
      
                SizedBox(height: 0.01 * getHeight(context)),
      
                Text('Category', style: TextStyle(fontSize: 20)),
                SizedBox(height: 0.01 * getHeight(context)),
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Medical ',
                  ),
                ),
                SizedBox(height: 0.01 * getHeight(context)),
                Text('Add peoples', style: TextStyle(fontSize: 20)),
                SizedBox(height: 0.01 * getHeight(context)),
                TextFormField(
                  controller: peopleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Add peoples@gmail.com',
      
                    suffixIcon: Icon(Icons.share),
                  ),
                ),
                SizedBox(height: 0.01 * getHeight(context)),
                Text('Priority', style: TextStyle(fontSize: 20)),
                SizedBox(height: 0.01 * getHeight(context)),
                TextFormField(
                  controller: priorityController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'low',
                  ),
                ),
                SizedBox(height: 0.01 * getHeight(context)),
                Text('Description', style: TextStyle(fontSize: 20)),
                SizedBox(height: 0.01 * getHeight(context)),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '2715 Ash Dr.San Jose, South Dakota 83475',
                  ),
                ),
      
                SizedBox(height: 0.03 * getHeight(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        minimumSize: Size(170, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        titleController.clear();
                        categoryController.clear();
                        peopleController.clear();
                        priorityController.clear();
                        descriptionController.clear();
                        reminderController.clear();
                        selectedDateTime = null;
                        _formKey.currentState?.reset();
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18
                        ),
                      ),
                    ),
      
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(170, 45),
                        backgroundColor: Colors.indigoAccent,
      
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final Box<Task> box = Hive.box<Task>('tasks');
                          if (isEditing && index != null) {
                            final task = Task(
                              title: titleController.text,
                              category: categoryController.text,
                              people: peopleController.text,
                              priority: priorityController.text,
                              description: descriptionController.text,
                              reminder: selectedDateTime,
                              status: false,
                            );
                              await box.putAt(index, task);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Task updated successfully"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            final task = Task(
                              title: titleController.text,
                              category: categoryController.text,
                              people: peopleController.text,
                              priority: priorityController.text,
                              description: descriptionController.text,
                              reminder: selectedDateTime,
                              status: false,
                            );
                            //final Box<Task> box = Hive.box<Task>('tasks');
                            await box.add(task);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Task added successfully"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                        
      
                            titleController.clear();
                            categoryController.clear();
                            peopleController.clear();
                            priorityController.clear();
                            descriptionController.clear();
                            reminderController.clear();
                            selectedDateTime = null;
                            _formKey.currentState?.reset();
                          }
                        }
                      },
                      child: Text(
                        'Create',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
