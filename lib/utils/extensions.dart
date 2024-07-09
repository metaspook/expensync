import 'package:flutter/foundation.dart';

extension NullableObjectExt on Object? {
  /// A string representation of this object.
  /// * Parse `null` into 'N/A' (Not Available) or given value.
  /// * See also [toString] doc comment.
  String toStringParseNull([String value = 'N/A']) =>
      this == null ? value : toString();

  /// Extension representation of [print] method. Levels: 0	Success,
  /// 1 Warnings, 2 Errors, 3 Info (default).
  void doPrint([String prefix = '', int level = 3]) {
    if (kDebugMode) {
      final code = switch (level) { 0 => 36, 1 => 33, 2 => 31, _ => 32 };
      final text = '\x1B[${code}m$prefix${toString()}\x1B[0m';
      // ignore: avoid_print
      RegExp('.{1,800}').allMatches(text).map((m) => m.group(0)).forEach(print);

      // RegExp('.{1,800}')
      //     .allMatches(text)
      //     .map((m) => m.group(0))
      //     .forEach((element) {});
    }
  }
}
