import 'package:equatable/equatable.dart';
import 'package:powersync/sqlite3_common.dart' as sqlite;

final class Todo extends Equatable {
  const Todo({
    required this.id,
    required this.ownerId,
    this.description,
  });

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      description: map['description'] as String?,
    );
  }

  factory Todo.fromRow(sqlite.Row row) {
    return Todo(
      id: row['id'] as String,
      description: row['description'] as String,
      ownerId: row['created_by'] as String,
    );
  }

  final String id;
  final String ownerId;
  final String? description;

  Todo copyWith({
    String? id,
    String? ownerId,
    String? description,
  }) {
    return Todo(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, ownerId, description];
}
