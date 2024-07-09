import 'package:equatable/equatable.dart';
import 'package:expensync/shared/models/models.dart';
import 'package:expensync/shared/repositories/repositories.dart';
import 'package:expensync/utils/utils.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'expenses_state.dart';

class ExpensesCubit extends HydratedCubit<ExpensesState> {
  ExpensesCubit({required ExpenseRepo expenseRepo})
      : _expenseRepo = expenseRepo,
        super(const ExpensesState());

  final ExpenseRepo _expenseRepo;

  Future<void> addExpense(Expense expense, {required Tasker tasker}) async {
    // Local operation.
    emit(
      state.copyWith(
        statusMsg: 'New Expense Added!',
        expenses: [...state.expenses, expense],
      ),
    );
    // Remote operation.
    await tasker(() => _expenseRepo.create(expense));
  }

  // void removeExpense(Expense expense) {
  //   final newExpenses = [...state.expenses]..remove(expense);
  //   emit(state.copyWith(expenses: newExpenses));
  // }

  void updateExpense(int index, Expense expense) {
    final newExpenses = [...state.expenses]..[index] = expense;
    emit(state.copyWith(expenses: newExpenses));
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
}
