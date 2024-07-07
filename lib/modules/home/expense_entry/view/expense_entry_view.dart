import 'package:flutter/material.dart';

class ExpenseEntryView extends StatelessWidget {
  const ExpenseEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const TextField(
          decoration: InputDecoration(
            label: Text('Name'),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            label: Text('Amount'),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () {}, child: const Text('Submit')),
      ],
    );
  }
}
