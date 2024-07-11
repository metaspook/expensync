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
    this.online = false,
  });

  final ExpensesStatus status;
  final String? statusMsg;
  final List<Expense> expenses;
  final List<Expense> selectedExpenses;
  final bool online;

  bool get selectionEnabled => selectedExpenses.isNotEmpty;

  ExpensesState copyWith({
    ExpensesStatus? status,
    String? statusMsg,
    List<Expense>? expenses,
    List<Expense>? selectedExpenses,
    bool? online,
  }) {
    return ExpensesState(
      status: status ?? this.status,
      statusMsg: statusMsg ?? this.statusMsg,
      expenses: expenses ?? this.expenses,
      selectedExpenses: selectedExpenses ?? this.selectedExpenses,
      online: online ?? this.online,
    );
  }

  @override
  List<Object?> get props =>
      [status, statusMsg, expenses, selectedExpenses, online];
}
