part of 'expenses_cubit.dart';

enum ExpensesStatus {
  initial,
  loading,
  success,
  failure;

  const ExpensesStatus();
  bool get isLoading => this == ExpensesStatus.loading;
}

class ExpensesState extends Equatable {
  const ExpensesState({
    this.status = ExpensesStatus.initial,
    this.statusMsg,
    this.expenses = const [],
    this.selectedExpenses = const [],
  });

  final ExpensesStatus status;
  final String? statusMsg;
  final List<Todo> expenses;
  final List<Todo> selectedExpenses;

  bool get selectionEnabled => selectedExpenses.isNotEmpty;

  ExpensesState copyWith({
    ExpensesStatus? status,
    String? statusMsg,
    List<Todo>? expenses,
    List<Todo>? selectedExpenses,
  }) {
    return ExpensesState(
      status: status ?? this.status,
      statusMsg: statusMsg ?? this.statusMsg,
      expenses: expenses ?? this.expenses,
      selectedExpenses: selectedExpenses ?? this.selectedExpenses,
    );
  }

  @override
  List<Object?> get props => [status, statusMsg, expenses, selectedExpenses];
}
