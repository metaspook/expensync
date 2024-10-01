part of 'expenses_cubit.dart';

enum ExpensesStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
}

class ExpensesState extends Equatable {
  const ExpensesState({
    this.status = ExpensesStatus.initial,
    this.statusMsg,
    this.expenses = const [],
    this.selectedExpenses = const [],
  });

  factory ExpensesState.fromJson(Map<String, dynamic> json) {
    print(json);
    return ExpensesState(
      expenses: [
        for (final e in json['expenses'] as List)
          Expense.fromJson(e as Map<String, dynamic>),
      ],
    );
  }

  final ExpensesStatus status;
  final String? statusMsg;
  final List<Expense> expenses;
  final List<Expense> selectedExpenses;

  bool get selectionEnabled => selectedExpenses.isNotEmpty;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'expenses': expenses.map((e) => e.toJson()).toList()};

  ExpensesState copyWith({
    ExpensesStatus? status,
    String? statusMsg,
    List<Expense>? expenses,
    List<Expense>? selectedExpenses,
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
