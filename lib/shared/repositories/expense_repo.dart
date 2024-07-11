import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:expensync/shared/models/models.dart';
import 'package:expensync/shared/services/database.dart';
import 'package:expensync/utils/utils.dart';

class ExpenseRepo implements CRUD<ExpenseCompanion, Expense?> {
  //   final _cacheExpenses = <Expense>[];
  final _db = AppDatabase();
  // final _errorMsgNotFound = 'Expenses not found!';
  // final _errorMsg = "Couldn't get the Expenses!";
  final _errorMsgCreate = "Couldn't create the Expense!";
  final _errorMsgRead = "Couldn't read the Expense data!";
  final _errorMsgUpdate = "Couldn't update the Expenses!";
  final _errorMsgDelete = "Couldn't delete the Expenses!";

  Stream<List<Expense>> get streamList {
    final query = _db.expense.select()
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.updatedAt, mode: OrderingMode.desc),
      ]);
    return query.map(Expense.fromData).watch();
  }

  //   Future<void> deleteAllTask() async {
  //   await db.expense.delete().go();
  // }

  @override
  Future<String?> create(String id, {required ExpenseCompanion value}) async {
    try {
      await _db.expense.insertOne(value);
    } catch (e, s) {
      log(_errorMsgCreate, error: e, stackTrace: s);
      return _errorMsgCreate;
    }
    return null;
  }

  @override
  Future<String?> delete(String id) async {
    try {
      await _db.expense.deleteWhere((table) => table.id.equals(id));
    } catch (e, s) {
      log(_errorMsgDelete, error: e, stackTrace: s);
      return _errorMsgDelete;
    }
    return null;
  }

  @override
  Future<(String?, Expense?)> read(String id) async {
    Expense? expense;
    try {
      final data = await (_db.select(_db.expense)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingle();
      expense = Expense.fromData(data);
    } catch (e, s) {
      log(_errorMsgRead, error: e, stackTrace: s);
      return (_errorMsgRead, null);
    }
    return (null, expense);
  }

  @override
  Future<String?> update(String id, {required ExpenseCompanion value}) async {
    try {
      await (_db.expense.update()..where((table) => table.id.equals(id)))
          .write(value);
    } catch (e, s) {
      log(_errorMsgUpdate, error: e, stackTrace: s);
      return _errorMsgUpdate;
    }
    return null;
  }
}
