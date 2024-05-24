// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.35.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'model.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:uuid/uuid.dart';

String greet({required String name, dynamic hint}) =>
    RustLib.instance.api.crateApiSimpleGreet(name: name, hint: hint);

List<Task> tasksByCompletion({required bool isCompleted, dynamic hint}) =>
    RustLib.instance.api
        .crateApiSimpleTasksByCompletion(isCompleted: isCompleted, hint: hint);

List<Task> tasksByPriority({required Priority priority, dynamic hint}) =>
    RustLib.instance.api
        .crateApiSimpleTasksByPriority(priority: priority, hint: hint);

void createTask(
        {required String taskTitle,
        required String taskSubtitle,
        required Priority taskPriority,
        dynamic hint}) =>
    RustLib.instance.api.crateApiSimpleCreateTask(
        taskTitle: taskTitle,
        taskSubtitle: taskSubtitle,
        taskPriority: taskPriority,
        hint: hint);

List<Task> readAllTasks(
        {required DateTime createdAt,
        required bool isCompletedOnly,
        required bool isIgnoreCreatedAt,
        dynamic hint}) =>
    RustLib.instance.api.crateApiSimpleReadAllTasks(
        createdAt: createdAt,
        isCompletedOnly: isCompletedOnly,
        isIgnoreCreatedAt: isIgnoreCreatedAt,
        hint: hint);

Task? readTask({required UuidValue taskId, dynamic hint}) =>
    RustLib.instance.api.crateApiSimpleReadTask(taskId: taskId, hint: hint);

void updateTask(
        {required UuidValue taskId,
        required String title,
        required String subtitle,
        required Priority priority,
        required bool isCompleted,
        dynamic hint}) =>
    RustLib.instance.api.crateApiSimpleUpdateTask(
        taskId: taskId,
        title: title,
        subtitle: subtitle,
        priority: priority,
        isCompleted: isCompleted,
        hint: hint);

void deleteTask({required UuidValue taskId, dynamic hint}) =>
    RustLib.instance.api.crateApiSimpleDeleteTask(taskId: taskId, hint: hint);

void deleteTasks({dynamic hint}) =>
    RustLib.instance.api.crateApiSimpleDeleteTasks(hint: hint);

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<rusqlite :: Error>>
@sealed
class RusqliteError extends RustOpaque {
  RusqliteError.dcoDecode(List<dynamic> wire)
      : super.dcoDecode(wire, _kStaticData);

  RusqliteError.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_RusqliteError,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_RusqliteError,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_RusqliteErrorPtr,
  );
}
