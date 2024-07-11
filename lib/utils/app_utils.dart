import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AppUtils {
  static String get uuid => const Uuid().v4();
  // genUUID()

  /// Current UTC DateTime.
  static DateTime get dateTime => DateTime.now().toUtc();

  /// Current UTC DateTime as String.
  static String get dateTimeStr => dateTime.toString();

  static void unfocus() => FocusManager.instance.primaryFocus?.unfocus();
}

typedef Json = Map<String, dynamic>;
typedef Tasker = Future<void> Function(Future<Object?> Function() task);
