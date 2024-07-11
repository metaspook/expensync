import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:expensync/shared/models/models.dart';
import 'package:expensync/shared/repositories/expense_repo.dart';
import 'package:expensync/shared/services/database.dart';
import 'package:expensync/shared/services/electric_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit({required ExpenseRepo expenseRepo})
      : _expenseRepo = expenseRepo,
        super(const ExpensesState()) {
    _expensesSubscription = _expenseRepo.streamList.listen((expenses) {
      emit(state.copyWith(expenses: expenses));
    });
  }

  final ExpenseRepo _expenseRepo;
  final client = ElectricService.instance.electricClient;
  StreamSubscription<List<Expense>>? _expensesSubscription;

  Future<void> syncTable() async {
    if (client != null && client!.isConnected) {
      await client!.syncTable(client!.db.expense);
    }
  }

  Future<void> addExpense(Expense expense) async {
    final expenseCompanion = ExpenseCompanion.insert(
      id: expense.id,
      name: Value(expense.name),
      amount: expense.amount,
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
    );
    final errorMsg =
        await _expenseRepo.create(expense.id, value: expenseCompanion);
    emit(
      errorMsg == null
          ? state.copyWith(
              statusMsg: 'New Expense Added!',
              expenses: [...state.expenses, expense],
            )
          : state.copyWith(statusMsg: errorMsg),
    );
  }

  Future<void> updateExpense(int index, Expense expense) async {
    final expenseCompanion = ExpenseCompanion(
      name: Value(expense.name),
      amount: Value(expense.amount),
      createdAt: Value(expense.createdAt),
      updatedAt: Value(expense.updatedAt),
    );
    final errorMsg =
        await _expenseRepo.update(expense.id, value: expenseCompanion);
    emit(
      errorMsg == null
          ? state.copyWith(
              statusMsg: 'Expense Updated!',
              expenses: [...state.expenses, expense],
            )
          : state.copyWith(statusMsg: errorMsg),
    );
  }

  void deselectAll() {
    emit(state.copyWith(selectedExpenses: []));
  }

  Future<void> removeAllSelectedExpense() async {
    final prevSelectedExpenses = [...state.selectedExpenses];
    // Local operation.
    final newExpenses = [...state.expenses];
    for (final expense in prevSelectedExpenses) {
      newExpenses.removeWhere((current) => current == expense);
    }
    emit(
      state.copyWith(
        statusMsg: 'Selected Expenses Deleted!',
        expenses: newExpenses,
        selectedExpenses: [],
      ),
    );
    // Remote operation.
    for (final expense in prevSelectedExpenses) {
      await _expenseRepo.delete(expense.id);
    }
  }

  void selectExpense(Expense expense) {
    emit(
      state.selectedExpenses.contains(expense)
          ? state.copyWith(
              selectedExpenses: [...state.selectedExpenses]..remove(expense),
            )
          : state
              .copyWith(selectedExpenses: [...state.selectedExpenses, expense]),
    );
  }

  @override
  Future<void> close() {
    _expensesSubscription?.cancel();
    // _expenseRepo.dispose();
    return super.close();
  }
}
