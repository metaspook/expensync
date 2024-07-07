import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'expense_entry_state.dart';

class ExpenseEntryCubit extends Cubit<ExpenseEntryState> {
  ExpenseEntryCubit() : super(ExpenseEntryInitial());
}
