import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit() : super(ExpensesInitial());
}
