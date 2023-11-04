import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_back4app/components/accordion.dart';
import 'package:task_back4app/components/app_bar_gradient.dart';
import 'package:task_back4app/components/delete_dialog.dart';
import 'package:task_back4app/components/text_form_field.dart';
import 'package:task_back4app/models/task.dart';
import 'package:task_back4app/providers/task_provider.dart';

class DetailsScreen extends StatefulWidget {
  static const route = "/details-screen";

  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Timer? titleDebounce;
  Timer? descriptionDebounce;

  var isEditing = false;

  List<String> statusItems = [
    "Not Started",
    "In Progress",
    "Done",
  ];

// This is commented because when last api call is triggered for update it must be fulfilled even though user changed the screen
  // @override
  // void dispose() {
  //   titleDebounce.cancel();
  //   descriptionDebounce.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    final task = arguments["task"] as Task;

    titleController.text = task.title;
    descriptionController.text = task.description;

    List<String> unselectedStatuses = statusItems
        .where(
          (element) => element != task.status,
        )
        .toList();

    return Consumer<TaskProvider>(builder: (context, taskContext, child) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 160),
          child: AppBarGradient(
            title: "Details",
            isDeleteActive: true,
            onDelete: () {
              showDeleteDialog(context, () {
                taskContext.deleteTask(task);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    content: const Text(
                      "Task Deleted.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                );
              });
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Created on: ${task.createdAt.toLocal()}"),
                          Text("Last updated on: ${task.updatedAt.toLocal()}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: CustomTextFormField(
                        labelText: "Title",
                        disabled: task.status == "Done",
                        keyboardType: TextInputType.text,
                        controller: titleController,
                        noBorder: true,
                        fontSize: 25,
                        textInputAction: TextInputAction.done,
                        textDecoration: task.status == "Done"
                            ? TextDecoration.lineThrough
                            : null,
                        onChanged: (value) {
                          task.title = value;
                          // titleController.text = value;
                          if (titleDebounce != null &&
                              titleDebounce!.isActive) {
                            titleDebounce!.cancel();
                          }
                          titleDebounce =
                              Timer(const Duration(milliseconds: 500), () {
                            taskContext.updateTitle(task); //DB Update
                          });
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Status"),
                    ),
                    Accordion(
                      title: task.status,
                      openedHeight: 100,
                      initiallyOpen: false,
                      child: ListView.builder(
                        itemCount: unselectedStatuses.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            key: UniqueKey(),
                            title: Text(unselectedStatuses[index]),
                            onTap: () {
                              task.status = unselectedStatuses[index];
                              task.updatedAt = DateTime.now();
                              taskContext.updateTask(task); //UI Update
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text(
                                    "Status Changed: ${task.status}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              );
                              taskContext.updateStatus(task); //DB Update
                              setState(() {
                                unselectedStatuses = statusItems
                                    .where((element) => element != task.status)
                                    .toList();
                                if (task.status == "Done") {
                                  isEditing = false;
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Text(
                        task.status == "Done"
                            ? "Done task cant be edited."
                            : "Double tap description to toggle editing.",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          return true;
                        }
                        return false;
                      },
                      child: GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            if (task.status != "Done") {
                              isEditing = !isEditing;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Description"),
                              !isEditing
                                  ? SizedBox(
                                      height: 500,
                                      width: double.infinity,
                                      child: Text(
                                        task.description,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            decoration: task.status == "Done"
                                                ? TextDecoration.lineThrough
                                                : null),
                                      ),
                                    )
                                  : CustomTextFormField(
                                      labelText: "",
                                      disabled: task.status == "Done",
                                      keyboardType: TextInputType.text,
                                      controller: descriptionController,
                                      noBorder: true,
                                      minLines: 6,
                                      maxLines: 25,
                                      textInputAction: TextInputAction.done,
                                      textDecoration: task.status == "Done"
                                          ? TextDecoration.lineThrough
                                          : null,
                                      onChanged: (value) {
                                        task.description = value;
                                        // descriptionController.text = value;
                                        if (descriptionDebounce != null &&
                                            descriptionDebounce!.isActive) {
                                          descriptionDebounce!.cancel();
                                        }
                                        descriptionDebounce = Timer(
                                            const Duration(milliseconds: 500),
                                            () {
                                          taskContext.updateDescription(
                                              task); // DB Update
                                        });
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
