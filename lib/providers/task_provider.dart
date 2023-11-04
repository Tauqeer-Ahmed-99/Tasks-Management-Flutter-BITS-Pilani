import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_back4app/models/task.dart';

class TaskProvider extends ChangeNotifier {
  var isTaskLoading = true;

  List<Task> tasks = [];

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final user = await ParseUser.currentUser() as ParseUser;

    final getUserTasksQuery = QueryBuilder<ParseObject>(ParseObject('Task'));
    getUserTasksQuery.whereContains("userId", user.objectId as String);

    final ParseResponse response = await getUserTasksQuery.query();

    if (response.success && response.results != null) {
      List<Task> tasksList = [];
      for (var rawTask in response.results!) {
        var task = Task(
          id: rawTask["objectId"],
          title: rawTask["title"],
          description: rawTask["description"],
          status: rawTask["status"],
          createdAt: rawTask["createdAt"],
          updatedAt: rawTask["updatedAt"],
        );

        tasksList.add(task);
        tasks = tasksList;
      }
    }
    isTaskLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final user = await ParseUser.currentUser() as ParseUser;

    final dbTask = ParseObject('Task')
      ..set("userId", user)
      ..set("title", task.title)
      ..set("description", task.description)
      ..set('status', task.status);

    await dbTask.save();

    task.id = dbTask.objectId;
    tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = tasks.indexWhere((element) => element.id == task.id);
    if (index > -1) {
      tasks[index] = task;
    }
    notifyListeners();
  }

  Future<void> updateTitle(Task task) async {
    print(task.title);
    final dbTask = ParseObject('Task')
      ..objectId = task.id
      ..set("title", task.title);

    await dbTask.save();

    print(task.title);
  }

  Future<void> updateDescription(Task task) async {
    final dbTask = ParseObject('Task')
      ..objectId = task.id
      ..set("description", task.description);

    await dbTask.save();
  }

  Future<void> updateStatus(Task task) async {
    final dbTask = ParseObject('Task')
      ..objectId = task.id
      ..set("status", task.status);

    await dbTask.save();
  }

  Future<void> deleteTask(Task task) async {
    final dbTask = ParseObject('Task')..objectId = task.id;

    await dbTask.delete();

    tasks.removeWhere((Task td) => td.id == task.id);

    notifyListeners();
  }
}
