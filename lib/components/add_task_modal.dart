import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_back4app/components/text_form_field.dart';
import 'package:task_back4app/models/task.dart';
import 'package:task_back4app/providers/task_provider.dart';

class AddTaskModal extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const AddTaskModal({super.key, required this.scaffoldKey});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<TaskProvider>(builder: (context, taskContext, child) {
        return Container(
          // height: MediaQuery.of(context).size.height / 2,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "New Task",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1E2E3D),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  labelText: 'Title',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter title";
                    }
                    return null;
                  },
                  controller: titleController,
                ),
                CustomTextFormField(
                  labelText: 'Description',
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  controller: descriptionController,
                  minLines: 3,
                  maxLines: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancel",
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff1E2E3D)),
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        var isFormValid = _formKey.currentState!.validate();
                        if (isFormValid) {
                          final newTask = Task(
                            title: titleController.text.trim(),
                            description: descriptionController.text,
                            status: "Not Started",
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
                          taskContext.addTask(newTask);

                          titleController.clear();
                          descriptionController.clear();

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: const Text(
                                "New Task Created.",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add_circle_rounded),
                      label: const Text("Create"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(
                                  0xff1E2E3D); // Color for the pressed state
                            }
                            return const Color(0xFF35516C);
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
