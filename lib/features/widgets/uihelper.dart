import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/features/model/task.dart';

import 'package:to_do_app/features/responsive.dart';

class Uihelper {
  static SizedBox verticalSpace(BuildContext context, [double factor = 0.01]) {
    return SizedBox(height: factor * getHeight(context));
  }

  static Widget customTextFormField({
    required TextEditingController controller,
    String? hintText,
    String? labelText,
    bool readOnly = false,
    IconData? suffixIcon,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
    );
  }

  static Widget formLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 18));
  }


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

    void clearForm() {
      titleController.clear();
      categoryController.clear();
      peopleController.clear();
      priorityController.clear();
      descriptionController.clear();
      reminderController.clear();
      selectedDateTime = null;
      _formKey.currentState?.reset();
    }

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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                formLabel('Title name'),

                verticalSpace(context, 0.01),
                TextFormField(
                  controller: titleController,
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'dr.appointment',
                  ),
                ),

                verticalSpace(context, 0.01),
                formLabel('Reminder'),

                customTextFormField(
                  controller: reminderController,
                  hintText: 'select data and time',
                  readOnly: true,
                  suffixIcon: Icons.calendar_today,
                  onTap: pickDateTime,
                ),

                verticalSpace(context, 0.01),
                formLabel('Category'),

                verticalSpace(context, 0.01),
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Medical ',
                  ),
                ),
                verticalSpace(context, 0.01),
                formLabel('Add peoples'),

                verticalSpace(context, 0.01),
                TextFormField(
                  controller: peopleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Add peoples@gmail.com',

                    suffixIcon: Icon(Icons.share),
                  ),
                ),
                verticalSpace(context, 0.01),
                formLabel('Priority'),

                verticalSpace(context, 0.01),
                TextFormField(
                  controller: priorityController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'low',
                  ),
                ),
                verticalSpace(context, 0.01),
                formLabel('Description'),

                verticalSpace(context, 0.01),
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
                        minimumSize: Size(0.180*getWidth(context), 0.45*getResponsive(context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        clearForm();
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18*getResponsive(context),
                        ),
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(170, 45),
                        backgroundColor: Colors.indigoAccent,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0*getResponsive(context)),
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
                            clearForm();
                          }
                        }
                      },
                      child: Text(
                        'Create',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18*getResponsive(context),
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
