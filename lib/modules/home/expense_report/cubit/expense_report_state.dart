part of 'expense_report_cubit.dart';

sealed class ExpenseReportState extends Equatable {
  const ExpenseReportState();

  @override
  List<Object> get props => [];
}

final class ExpenseReportInitial extends ExpenseReportState {}
