import 'package:expensync/modules/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final cubit = context.read<ExpensesCubit>();
    final expenses =
        context.select((ExpensesCubit cubit) => cubit.state.expenses);
    final selectedExpenses =
        context.select((ExpensesCubit cubit) => cubit.state.selectedExpenses);
    final isLoading =
        context.select((ExpensesCubit cubit) => cubit.state.status.isLoading);
    final selectionEnabled =
        context.select((ExpensesCubit cubit) => cubit.state.selectionEnabled);

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : expenses.isEmpty
            ? Center(
                child: Text(
                  'Empty',
                  style: themeData.textTheme.headlineLarge,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(5),
                physics: const BouncingScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[expenses.length - 1 - index];
                  final selected = selectedExpenses.contains(expense);
                  return Card(
                    child: ListTile(
                      selectedTileColor: themeData.primaryColorLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      selected: selected,
                      onTap: selectionEnabled
                          ? () => cubit.selectExpense(expense)
                          : null,
                      onLongPress: () => cubit.selectExpense(expense),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(expense.description ?? 'N/A'),
                        ],
                      ),
                      // trailing: Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Text(
                      //       '\$${expense.amount}',
                      //       style: themeData.textTheme.bodyLarge,
                      //     ),
                      //     IconButton(
                      //       visualDensity: const VisualDensity(
                      //         horizontal: VisualDensity.minimumDensity,
                      //         vertical: VisualDensity.minimumDensity,
                      //       ),
                      //       onPressed: selectionEnabled
                      //           ? null
                      //           : () => ExpenseEditDialog(expense)
                      //               .show(context, cubit: cubit),
                      //       icon: const Icon(Icons.edit_rounded),
                      //     ),
                      //   ],
                      // ),
                      // isThreeLine: true,
                      // subtitle: Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Text.rich(
                      //       style: themeData.textTheme.labelSmall?.copyWith(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //       TextSpan(
                      //         text: 'Created: ',
                      //         children: [
                      //           TextSpan(
                      //             text: expense.createdAt,
                      //             style:
                      //                 themeData.textTheme.labelSmall?.copyWith(
                      //               fontWeight: FontWeight.normal,
                      //             ),
                      //             children: const [],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Text.rich(
                      //       style: themeData.textTheme.labelSmall?.copyWith(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //       TextSpan(
                      //         text: 'Updated: ',
                      //         children: [
                      //           TextSpan(
                      //             text: expense.updatedAt,
                      //             style:
                      //                 themeData.textTheme.labelSmall?.copyWith(
                      //               fontWeight: FontWeight.normal,
                      //             ),
                      //             children: const [],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  );
                },
              );
  }
}
