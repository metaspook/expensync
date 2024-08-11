import 'package:uuid/uuid.dart';

/// Generates a unique id. `[RNG version 4 | random]`
String uuid() => const Uuid().v4();

/// String representation of the current UTC date and time.
String timestampStr() => DateTime.timestamp().toString();

/// A minimalistic in-memory cache service.
/// * Value type will be `Object?` if not specify in place of `T`.
Map<String, T> cacheMap<T extends Object?>() => <String, T>{};
