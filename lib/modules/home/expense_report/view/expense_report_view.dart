import 'dart:math';

import 'package:flutter/material.dart';

class ExpenseReportView extends StatelessWidget {
  const ExpenseReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Expenses:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                // decoration: TextDecoration.underline,
              ),
            ),
            Text(
              'Total: 250000',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                // decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        const Divider(thickness: 2),
        for (var i = 0; i < 10; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Expense ${i + 1}'),
              Text(Random().nextInt(300).toString()),
            ],
          ),
      ],
    );
  }
}
