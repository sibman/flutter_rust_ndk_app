import 'package:flutter/material.dart';
import 'package:flutter_rust_ndk_app/src/rust/api/simple.dart' as s;
import 'package:flutter_rust_ndk_app/src/rust/api/model.dart';
import 'package:uuid/uuid_value.dart';

class TaskPersistenceModel extends ChangeNotifier {
  final ValueNotifier<Task> _changer = ValueNotifier<Task>(
      Task(title: "", subtitle: "", priority: Priority.normalPriority()));

  /// Checking Done Tasks
  int countDoneTask() {
    List<Task> completedList = s.tasksByCompletion(isCompleted: true);

    // Access completedList after the async block finishes
    return completedList.length;
  }

  ValueNotifier<Task> notifier() {
    return _changer;
  }

  List<Task> readAllTasks(
      {required DateTime createdAt,
      required bool isCompletedOnly,
      required bool isIgnoreCreatedAt}) {
    List<Task> tasks = s.readAllTasks(
        createdAt: createdAt,
        isCompletedOnly: isCompletedOnly,
        isIgnoreCreatedAt: isIgnoreCreatedAt);
    return tasks;
  }

  List<Task> filterTasksByCompletion({required bool isCompleted}) {
    return s.tasksByCompletion(isCompleted: isCompleted);
  }

  List<Task> filterTasksByPriority({required Priority priority}) {
    return s.tasksByPriority(priority: priority);
  }

  void deleteTask({required UuidValue taskId}) {
    _changer.value = s.readTask(taskId: taskId)!;
    s.deleteTask(taskId: taskId);
    notifyListeners();
  }

  void deleteTasks() {
    s.deleteTasks();
    _changer.value =
        Task(title: "", subtitle: "", priority: Priority.normalPriority());
    notifyListeners();
  }

  void updateTask(
      {required UuidValue taskId,
      required String title,
      required String subtitle,
      required bool isCompleted,
      required Priority priority}) {
    String priorityStr = priority.toString();

    s.updateTask(
        taskId: taskId,
        title: title,
        subtitle: subtitle,
        isCompleted: isCompleted,
        priority: Priority.fromString(value: priorityStr));
    _changer.value = Task(
        title: title,
        subtitle: subtitle,
        priority: Priority.fromString(value: priorityStr));
    notifyListeners();
  }

  void createTask(
      {required taskTitle,
      required taskSubtitle,
      required Priority taskPriority}) {
    String priority = taskPriority.toString();

    s.createTask(
        taskTitle: taskTitle,
        taskSubtitle: taskSubtitle,
        taskPriority: Priority.fromString(value: priority));

    _changer.value = Task(
        title: taskTitle,
        subtitle: taskSubtitle,
        priority: Priority.fromString(value: priority));
    notifyListeners();
  }
}
