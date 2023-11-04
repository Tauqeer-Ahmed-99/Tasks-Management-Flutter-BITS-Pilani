import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_back4app/components/accordion.dart';
import 'package:task_back4app/components/add_task_modal.dart';
import 'package:task_back4app/components/app_bar_gradient.dart';
import 'package:task_back4app/components/delete_dialog.dart';
import 'package:task_back4app/components/skeleton.dart';
import 'package:task_back4app/models/task.dart';
import 'package:task_back4app/providers/task_provider.dart';
import 'package:task_back4app/providers/user_provider.dart';
import 'package:task_back4app/screens/details.dart';
import 'package:task_back4app/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  static const route = "/home-screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isDeletingSelectionActive = false;

  List<String> deleteSelectionIds = [];

  void _showAddTaskForm() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddTaskModal(
            scaffoldKey: _scaffoldKey,
          ),
        );
      },
    );
  }

  void handleTaskTap(Task task) {
    if (isDeletingSelectionActive) {
      setState(() {
        if (deleteSelectionIds.contains(task.id)) {
          deleteSelectionIds.removeWhere((id) => id == task.id);
          if (deleteSelectionIds.isEmpty) {
            isDeletingSelectionActive = false;
          }
        } else {
          deleteSelectionIds.add(task.id as String);
        }
      });
    } else {
      Navigator.of(context).pushNamed(
        DetailsScreen.route,
        arguments: {"task": task},
      );
    }
  }

  void handleTaskLongPress(Task task) {
    setState(() {
      isDeletingSelectionActive = true;

      deleteSelectionIds.add(task.id as String);
    });
  }

  void deleteSelectedTasks(TaskProvider taskContext) {
    showDeleteDialog(context, () {
      for (var id in deleteSelectionIds) {
        taskContext.deleteTask(
            taskContext.tasks.firstWhere((element) => element.id == id));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: const Text(
            "Selected Tasks Deleted.",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );

      setState(() {
        deleteSelectionIds = [];
        isDeletingSelectionActive = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 160),
        child: Consumer<TaskProvider>(
          builder: (context, taskContext, child) {
            return AppBarGradient(
              title: "Tasks",
              isDeleteActive: isDeletingSelectionActive,
              onDelete: () => deleteSelectedTasks(taskContext),
            );
          },
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userContext, child) {
          return Consumer<TaskProvider>(
            builder: (context, taskContext, child) {
              if (taskContext.isTaskLoading) {
                return const Center(
                  child: Skeleton(),
                );
              } else {
                if (taskContext.tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome ${userContext.user!.username}!",
                          style: const TextStyle(
                              color: Color.fromRGBO(81, 81, 81, 0.376),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Start adding new Tasks.",
                          style: TextStyle(
                            color: Color.fromARGB(96, 81, 81, 81),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  List<Task> notStartedTasks = taskContext.tasks
                      .where((task) => task.status == "Not Started")
                      .toList();
                  List<Task> inProgressTasks = taskContext.tasks
                      .where((task) => task.status == "In Progress")
                      .toList();
                  List<Task> doneTasks = taskContext.tasks
                      .where((task) => task.status == "Done")
                      .toList();
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Accordion(
                          title: "Not Started",
                          initiallyOpen: true,
                          openedHeight:
                              getAccordionHeight(notStartedTasks.length),
                          child: notStartedTasks.isEmpty
                              ? const ListTile(
                                  title: Text("No Task available."),
                                )
                              : ListView.builder(
                                  itemCount: notStartedTasks.length,
                                  itemBuilder: (context, index) {
                                    final task = notStartedTasks[index];
                                    return ListTile(
                                      selected:
                                          deleteSelectionIds.contains(task.id),
                                      selectedTileColor: const Color.fromARGB(
                                          255, 211, 224, 237),
                                      title: Text(task.title),
                                      subtitle: task.description.isNotEmpty
                                          ? Text(truncateString(
                                              task.description, 150))
                                          : null,
                                      onTap: () => handleTaskTap(task),
                                      onLongPress: () =>
                                          handleTaskLongPress(task),
                                    );
                                  },
                                ),
                        ),
                        Accordion(
                          title: "In Progress",
                          initiallyOpen: true,
                          openedHeight:
                              getAccordionHeight(inProgressTasks.length),
                          child: inProgressTasks.isEmpty
                              ? const ListTile(
                                  title: Text("No Task available."),
                                )
                              : ListView.builder(
                                  itemCount: inProgressTasks.length,
                                  itemBuilder: (context, index) {
                                    final task = inProgressTasks[index];
                                    return ListTile(
                                      selected:
                                          deleteSelectionIds.contains(task.id),
                                      selectedTileColor: const Color.fromARGB(
                                          255, 211, 224, 237),
                                      title: Text(task.title),
                                      subtitle: task.description.isNotEmpty
                                          ? Text(truncateString(
                                              task.description, 150))
                                          : null,
                                      onTap: () => handleTaskTap(task),
                                      onLongPress: () =>
                                          handleTaskLongPress(task),
                                    );
                                  },
                                ),
                        ),
                        Accordion(
                          title: "Done",
                          initiallyOpen: false,
                          openedHeight: getAccordionHeight(doneTasks.length),
                          child: doneTasks.isEmpty
                              ? const ListTile(
                                  title: Text("No Task available."),
                                )
                              : ListView.builder(
                                  itemCount: doneTasks.length,
                                  itemBuilder: (context, index) {
                                    final task = doneTasks[index];
                                    return ListTile(
                                      selected:
                                          deleteSelectionIds.contains(task.id),
                                      selectedTileColor: const Color.fromARGB(
                                          255, 211, 224, 237),
                                      title: Text(
                                        task.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          decoration: task.status == "Done"
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      subtitle: task.description.isNotEmpty
                                          ? Text(truncateString(
                                              task.description, 150))
                                          : null,
                                      onTap: () => handleTaskTap(task),
                                      onLongPress: () =>
                                          handleTaskLongPress(task),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Task",
        onPressed: () => _showAddTaskForm(),
        backgroundColor: const Color(0xff1E2E3D),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
