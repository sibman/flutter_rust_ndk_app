import 'package:flutter/material.dart';
import 'package:flutter_rust_ndk_app/src/rust/api/simple.dart' as s;
import 'package:flutter_rust_ndk_app/src/rust/api/model.dart';
import 'package:uuid/uuid_value.dart';

class TaskPersistenceModel extends ChangeNotifier {
  //TODO implement value change notification
  final ValueNotifier<Task> _changer = ValueNotifier<Task>(
      Task(title: "", subtitle: "", priority: Priority.low()));

  /// Checking Done Tasks
  int countDoneTask() {
    //List<Task> tasks
    List<Task> completedList = s.tasksByCompletion(isCompleted: true);

    // Access completedList after the async block finishes
    return completedList.length;
  }

  ValueNotifier<Task> notifier() {
    return _changer;
  }

  List<Task> readAllTasks() {
    List<Task> tasks = s.readAllTasks();
    return tasks;
  }

  void deleteTask({required UuidValue taskId}) {
    _changer.value = s.readTask(taskId: taskId)!;
    s.deleteTask(taskId: taskId);
    notifyListeners();
  }
}
