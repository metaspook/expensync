import 'package:flutter/material.dart';

class AppUtils {
  /// Current UTC DateTime.
  static DateTime get dateTime => DateTime.now().toUtc();

  /// Current UTC DateTime as String.
  static String get dateTimeStr => dateTime.toString();

  static void unfocus() => FocusManager.instance.primaryFocus?.unfocus();
}

typedef Tasker = Future<void> Function(Future<Object?> Function() task);
