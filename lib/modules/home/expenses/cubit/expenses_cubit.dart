import 'package:equatable/equatable.dart';
import 'package:expensync/shared/models/models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'expenses_state.dart';

class ExpensesCubit extends HydratedCubit<ExpensesState> {
  ExpensesCubit() : super(const ExpensesState());

  void addExpense(Expense expense) {
    emit(
      state.copyWith(
        statusMsg: 'New Expense Added!',
        expenses: [...state.expenses, expense],
      ),
    );
  }

  void removeExpense(Expense expense) {
    final newExpenses = [...state.expenses]..remove(expense);
    emit(state.copyWith(expenses: newExpenses));
  }

  void updateExpense(Expense expense) {
    emit(state.copyWith(expenses: [...state.expenses, expense]));
  }

  void selectExpense(Expense expense) {
    emit(
      state.copyWith(selectedExpenses: [...state.selectedExpenses, expense]),
    );
  }

  @override
  ExpensesState? fromJson(Map<String, dynamic> json) =>
      ExpensesState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ExpensesState state) => state.toJson();
}
