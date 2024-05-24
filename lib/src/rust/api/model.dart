// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.35.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:uuid/uuid.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Priority>>
@sealed
class Priority extends RustOpaque {
  Priority.dcoDecode(List<dynamic> wire) : super.dcoDecode(wire, _kStaticData);

  Priority.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_Priority,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_Priority,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_PriorityPtr,
  );

  static Priority fromString({required String value, dynamic hint}) =>
      RustLib.instance.api
          .crateApiModelPriorityFromString(value: value, hint: hint);

  static Priority highPriority({dynamic hint}) =>
      RustLib.instance.api.crateApiModelPriorityHighPriority(hint: hint);

  static Priority lowPriority({dynamic hint}) =>
      RustLib.instance.api.crateApiModelPriorityLowPriority(hint: hint);

  static Priority normalPriority({dynamic hint}) =>
      RustLib.instance.api.crateApiModelPriorityNormalPriority(hint: hint);

  String toString({dynamic hint}) => RustLib.instance.api
      .crateApiModelPriorityToString(that: this, hint: hint);
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Task>>
@sealed
class Task extends RustOpaque {
  Task.dcoDecode(List<dynamic> wire) : super.dcoDecode(wire, _kStaticData);

  Task.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_Task,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_Task,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_TaskPtr,
  );

  DateTime getCreatedAt({dynamic hint}) => RustLib.instance.api
      .crateApiModelTaskGetCreatedAt(that: this, hint: hint);

  UuidValue getId({dynamic hint}) =>
      RustLib.instance.api.crateApiModelTaskGetId(that: this, hint: hint);

  Priority getPriority({dynamic hint}) =>
      RustLib.instance.api.crateApiModelTaskGetPriority(that: this, hint: hint);

  String getSubtitle({dynamic hint}) =>
      RustLib.instance.api.crateApiModelTaskGetSubtitle(that: this, hint: hint);

  String getTitle({dynamic hint}) =>
      RustLib.instance.api.crateApiModelTaskGetTitle(that: this, hint: hint);

  bool isCompleted({dynamic hint}) =>
      RustLib.instance.api.crateApiModelTaskIsCompleted(that: this, hint: hint);

  factory Task(
          {required String title,
          required String subtitle,
          required Priority priority,
          dynamic hint}) =>
      RustLib.instance.api.crateApiModelTaskNew(
          title: title, subtitle: subtitle, priority: priority, hint: hint);

  void setCompleted({required bool isCompleted, dynamic hint}) =>
      RustLib.instance.api.crateApiModelTaskSetCompleted(
          that: this, isCompleted: isCompleted, hint: hint);

  void setCreatedAt({required DateTime createdAt, dynamic hint}) =>
      RustLib.instance.api.crateApiModelTaskSetCreatedAt(
          that: this, createdAt: createdAt, hint: hint);

  void setPriority({required Priority priority, dynamic hint}) => RustLib
      .instance.api
      .crateApiModelTaskSetPriority(that: this, priority: priority, hint: hint);

  void setSubtitle({required String subtitle, dynamic hint}) => RustLib
      .instance.api
      .crateApiModelTaskSetSubtitle(that: this, subtitle: subtitle, hint: hint);

  void setTitle({required String title, dynamic hint}) => RustLib.instance.api
      .crateApiModelTaskSetTitle(that: this, title: title, hint: hint);
}