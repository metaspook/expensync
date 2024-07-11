import 'package:expensync/app/app.dart';
import 'package:expensync/modules/home/home.dart';
import 'package:expensync/shared/models/models.dart';
import 'package:expensync/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseEntryView extends StatefulWidget {
  const ExpenseEntryView({super.key});

  @override
  State<ExpenseEntryView> createState() => _ExpenseEntryViewState();
}

class _ExpenseEntryViewState extends State<ExpenseEntryView> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _submitEnabled = ValueNotifier<bool>(false);
  late final Listenable _listenable;

  Expense get _expense {
    final dateTime = AppUtils.dateTime;
    return Expense(
      id: AppUtils.uuid,
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      createdAt: dateTime,
      updatedAt: dateTime,
    );
  }

  void _clearTextControllers() {
    _nameController.clear();
    _amountController.clear();
  }

  void _onTextChanged() {
    _submitEnabled.value =
        _nameController.text.isNotEmpty && _amountController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _listenable = Listenable.merge([_nameController, _amountController])
      ..addListener(_onTextChanged);
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
    // final themeData = Theme.of(context);
    final cubit = context.read<ExpensesCubit>();
    final appCubit = context.read<AppCubit>();

    return ListView(
      padding: const EdgeInsets.all(20),
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
        const SizedBox(height: 20),
        BlocListener<ExpensesCubit, ExpensesState>(
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
                  ? () async {
                      // await cubit.addExpense(_expense);
                      await cubit.addExpense(_expense);
                      _clearTextControllers();
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  : null,
              child: const Text('Submit'),
            ),
          ),
        ),
      ],
    );
  }
}
