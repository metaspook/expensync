import 'package:expensync/modules/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseReportView extends StatelessWidget {
  const ExpenseReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final expenses =
        context.select((ExpensesCubit cubit) => cubit.state.expenses);
    final total = expenses.isEmpty
        ? 0
        : expenses.map((e) => e.amount).reduce((v, e) => v + e);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Exp. Count: ${expenses.length}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                // decoration: TextDecoration.underline,
              ),
            ),
            Text(
              'Total: $total',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                // decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        const Divider(thickness: 2),
        if (expenses.isEmpty)
          Center(
            child: Text(
              'Empty',
              style: themeData.textTheme.titleLarge,
            ),
          )
        else
          for (var i = expenses.length - 1; i >= 0; i--)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(expenses[i].name ?? 'N/A'),
                Text(expenses[i].amount.toString()),
              ],
            ),
      ],
    );
  }
}
