import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'expense_report_state.dart';

class ExpenseReportCubit extends Cubit<ExpenseReportState> {
  ExpenseReportCubit() : super(ExpenseReportInitial());
}
