import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:expensync/shared/models/models.dart';
import 'package:expensync/shared/repositories/repositories.dart';
import 'package:expensync/utils/extensions.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit({required TodoRepo todoRepo})
      : _todoRepo = todoRepo,
        super(const ExpensesState()) {
    _todoRepo.listStream().listen((todos) {
      emit(state.copyWith(expenses: todos..doPrint()));
    });
  }

  final TodoRepo _todoRepo;
  StreamSubscription<List<Todo>>? _todosSubscription;

  Future<void> addExpense(Todo todo) async {
    final errorMsg = await _todoRepo.create('', value: todo.toJson());
    emit(
      errorMsg == null
          ? state.copyWith(
              status: ExpensesStatus.success,
              statusMsg: 'New Expense Added!',
            )
          : state.copyWith(status: ExpensesStatus.failure, statusMsg: errorMsg),
    );
  }

  Future<void> removeExpense(Todo expense) async {
    final errorMsg = await _todoRepo.delete(expense.id);
    emit(
      errorMsg == null
          ? state.copyWith(
              status: ExpensesStatus.success,
              statusMsg: 'Expense Removed!',
            )
          : state.copyWith(status: ExpensesStatus.failure, statusMsg: errorMsg),
    );
  }

  void updateExpense(int index, Todo expense) {
    final newExpenses = [...state.expenses]..[index] = expense;
    emit(state.copyWith(expenses: newExpenses));
  }

  void deselectAll() {
    emit(state.copyWith(selectedExpenses: []));
  }

  Future<void> removeAllSelectedExpense() async {
    final newExpenses = [...state.expenses];
    for (final expense in state.selectedExpenses) {
      await _todoRepo.delete(expense.id).then((errorMsg) {
        newExpenses.removeWhere((current) => current == expense);
        emit(
          errorMsg == null
              ? state.copyWith(
                  status: ExpensesStatus.success,
                  statusMsg: 'Expense Removed!',
                )
              : state.copyWith(
                  status: ExpensesStatus.failure,
                  statusMsg: errorMsg,
                ),
        );
      });
    }
    emit(state.copyWith(expenses: newExpenses, selectedExpenses: []));
  }

  void selectExpense(Todo expense) {
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
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}
