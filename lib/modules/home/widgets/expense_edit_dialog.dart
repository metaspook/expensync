import 'package:expensync/app/cubits/app_cubit.dart';
import 'package:expensync/modules/home/home.dart';
import 'package:expensync/shared/models/models.dart';
import 'package:expensync/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseEditDialog extends StatefulWidget {
  const ExpenseEditDialog(this.expense, {super.key});
  final Expense expense;

  void show<T>(BuildContext context, {required ExpensesCubit cubit}) {
    showDialog<T>(
      barrierDismissible: false,
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: this,
      ),
    );
  }

  @override
  State<ExpenseEditDialog> createState() => _ExpenseEditDialogState();
}

class _ExpenseEditDialogState extends State<ExpenseEditDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _submitEnabled = ValueNotifier<bool>(false);
  late final Listenable _listenable;

  Expense get _expense {
    final dateTimeStr = AppUtils.dateTimeStr;
    return widget.expense.copyWith(
      name: _nameController.text.trim(),
      amount: num.parse(_amountController.text.trim()),
      updatedAt: dateTimeStr,
    );
  }

  void _clearTextControllers() {
    _nameController.clear();
    _amountController.clear();
  }

  void _onTextChanged() {
    _submitEnabled.value = _nameController.text != widget.expense.name ||
        _amountController.text != widget.expense.amount.toString();
  }

  @override
  void initState() {
    super.initState();

    _listenable = Listenable.merge(
      [
        _nameController..text = widget.expense.name ?? '',
        _amountController..text = widget.expense.amount.toString(),
      ],
    )..addListener(_onTextChanged);
    //  _nameController..text = widget.expense.name ?? '',
    //     _amountController ..text = widget.expense.amount.toString(),
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _listenable.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpensesCubit>();
    final appCubit = context.read<AppCubit>();
    final themeData = Theme.of(context);

    return AlertDialog(
      backgroundColor: themeData.scaffoldBackgroundColor.withOpacity(.875),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Edit Expense'),
          IconButton(
            padding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.cancel_rounded),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        // padding: const EdgeInsets.all(20),
        children: [
          // Name Field
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              label: const Text('Name'),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.5)),
            ),
          ),
          const SizedBox(height: 20),
          // Amount Field
          TextField(
            keyboardType: TextInputType.number,
            controller: _amountController,
            decoration: InputDecoration(
              label: const Text('Amount'),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.5)),
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: BlocListener<ExpensesCubit, ExpensesState>(
            listener: (context, state) {
              final statusMsg = state.statusMsg;
              if (statusMsg != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(statusMsg)));
              }
            },
            child: ValueListenableBuilder(
              valueListenable: _submitEnabled,
              builder: (context, value, child) => ElevatedButton(
                onPressed: value
                    ? () {
                        Navigator.of(context).pop();
                        final expenseIndex =
                            cubit.state.expenses.indexOf(widget.expense);
                        cubit.updateExpense(
                          expenseIndex,
                          _expense,
                          tasker: appCubit.doTask,
                        );
                        _clearTextControllers();
                      }
                    : null,
                child: const Text('Submit'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
