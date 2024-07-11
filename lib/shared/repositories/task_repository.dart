import 'package:drift/drift.dart';
import 'package:expensync/shared/models/expense.dart';
import 'package:expensync/shared/services/database.dart';

class TaskRepositoryImpl extends ExpenseRepository {
  TaskRepositoryImpl({required this.db});
  final AppDatabase db;

  @override
  Future<void> close() async {
    await db.close();
  }

  @override
  Future<void> createNewTask(Expense expense) async {
    await db.expense.insertOne(
      ExpenseCompanion.insert(
        id: expense.id,
        name: Value(expense.name),
        amount: expense.amount,
        createdAt: expense.createdAt,
        updatedAt: expense.updatedAt,
      ),
    );
  }

  @override
  Future<void> deleteAllTask() async {
    await db.expense.delete().go();
  }

  @override
  Future<void> deleteTask(String id) async {
    await db.expense.deleteWhere((tbl) => tbl.id.equals(id));
  }

  @override
  Stream<List<Expense>> getTasks() {
    return (db.expense.select()
          ..orderBy(
            [
              (tbl) => OrderingTerm(
                    expression: tbl.updatedAt,
                    mode: OrderingMode.desc,
                  ),
            ],
          ))
        .map(
          (expense) => Expense(
            id: expense.id,
            name: expense.name,
            amount: expense.amount,
            createdAt: expense.createdAt,
            updatedAt: expense.updatedAt,
          ),
        )
        .watch();
  }

  @override
  Future<void> updateTask(Expense expense) async {
    await (db.expense.update()
          ..where(
            (tbl) => tbl.id.equals(expense.id),
          ))
        .write(
      ExpenseCompanion(
        name: Value(expense.name),
        amount: Value(expense.amount),
        createdAt: Value(expense.createdAt),
        updatedAt: Value(expense.updatedAt),
      ),
    );
  }
}

abstract class ExpenseRepository {
  Future<void> createNewTask(Expense expense);

  Stream<List<Expense>> getTasks();

  Future<void> updateTask(Expense item);

  Future<void> deleteTask(String id);

  Future<void> deleteAllTask();

  Future<void> close();
}
