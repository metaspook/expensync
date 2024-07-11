import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:expensync/shared/models/models.dart';
import 'package:expensync/shared/repositories/repositories.dart';
import 'package:expensync/utils/utils.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'expenses_state.dart';

class ExpensesCubit extends HydratedCubit<ExpensesState> {
  ExpensesCubit({required ExpenseRepo expenseRepo})
      : _expenseRepo = expenseRepo,
        super(const ExpensesState()) {
    _expensesSubscription = _expenseRepo.streamList.listen((expenses) {
      emit(state.copyWith(expenses: expenses));
    });
  }

  final ExpenseRepo _expenseRepo;
  StreamSubscription<List<Expense>>? _expensesSubscription;

  Future<void> addExpense(Expense expense, {required Tasker tasker}) async {
    // Local operation.
    emit(
      state.copyWith(
        statusMsg: 'New Expense Added!',
        expenses: [...state.expenses, expense],
      ),
    );
    final expenseJson = {
      'name': expense.name,
      'amount': expense.amount,
      'createdAt': expense.createdAt,
      'updatedAt': expense.updatedAt,
    };
    // Remote operation.
    await tasker(() => _expenseRepo.create(expense.id, value: expenseJson));
  }

  Future<void> updateExpense(
    int index,
    Expense expense, {
    required Tasker tasker,
  }) async {
    // Local operation.
    final newExpenses = [...state.expenses]..[index] = expense;
    emit(state.copyWith(expenses: newExpenses));
    final expenseJson = {
      'name': expense.name,
      'amount': expense.amount,
      'createdAt': expense.createdAt,
      'updatedAt': expense.updatedAt,
    };
    // Remote operation.
    await tasker(() => _expenseRepo.update(expense.id, value: expenseJson));
  }

  void deselectAll() {
    emit(state.copyWith(selectedExpenses: []));
  }

  Future<void> removeAllSelectedExpense({
    required Tasker tasker,
  }) async {
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
      await tasker(() => _expenseRepo.delete(expense.id));
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
    print(state.selectedExpenses);
  }

  @override
  ExpensesState? fromJson(Map<String, dynamic> json) =>
      ExpensesState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ExpensesState state) => state.toJson();

  @override
  Future<void> close() {
    _expensesSubscription?.cancel();
    _expenseRepo.dispose();
    return super.close();
  }
}
