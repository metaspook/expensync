import 'dart:developer';

import 'package:expensync/shared/models/models.dart';
import 'package:expensync/utils/utils.dart';

class TodoRepo implements CRUD<Map<String, dynamic>, Todo?> {
  //-- Config
  // final _cache = const Cache<List<String>>('departments');
  final _powerSyncHelper = PowerSyncHelper();
  final _errorMsgDepartmentsNotFound = 'Departments not found!';
  final _errorMsgDepartments = "Couldn't get the departments!";
  final _errorMsgCreate = "Couldn't create the Todo!";
  final _errorMsgRead = "Couldn't read the Todo data!";
  final _errorMsgUpdate = "Couldn't update the Todo!";
  final _errorMsgDelete = "Couldn't delete the Todo!";
  final _uuid = uuid();

  //-- Public APIs
  Stream<List<Todo>> listStream() {
    return _powerSyncHelper.db.watch(
      'SELECT * FROM todos WHERE list_id = ? ORDER BY created_at DESC',
      parameters: [_uuid],
    ).map((event) {
      return event.map(Todo.fromRow).toList(growable: false);
    });
  }

  @override
  Future<String?> create(
    String id, {
    required Map<String, dynamic> value,
  }) async {
    try {
      await _powerSyncHelper.db.execute(
        '''
INSERT INTO
          todos(id, created_at, completed, list_id, description, created_by)
          VALUES(uuid(), datetime(), FALSE, ?, ?, ?)
          RETURNING *''',
        [_uuid, value['description'], value['ownerId']],
      );
    } catch (e, s) {
      log(_errorMsgCreate, error: e, stackTrace: s);
      return _errorMsgCreate;
    }
    return null;
  }

  @override
  Future<String?> delete(String id) async {
    try {
      await _powerSyncHelper.db.execute('DELETE FROM todos WHERE id = ?', [id]);
    } catch (e, s) {
      log(_errorMsgDelete, error: e, stackTrace: s);
      return _errorMsgDelete;
    }
    return null;
  }

  @override
  Future<(String?, Todo?)> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<String?> update(String id, {required Map<String, dynamic> value}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
