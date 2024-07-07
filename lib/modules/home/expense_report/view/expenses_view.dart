import 'package:flutter/material.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(5),
      physics: const BouncingScrollPhysics(),
      itemCount: 25,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Expense ${index + 1}'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  r'$200',
                  style: themeData.textTheme.bodyLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.edit_rounded),
                    ),
                    IconButton(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.delete_forever_rounded),
                    ),
                  ],
                ),
              ],
            ),
            // isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  style: themeData.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  TextSpan(
                    text: 'Created: ',
                    children: [
                      TextSpan(
                        text: DateTime.now().toUtc().toString(),
                        style: themeData.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                        children: const [],
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  style: themeData.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  TextSpan(
                    text: 'Updated: ',
                    children: [
                      TextSpan(
                        text: DateTime.now().toUtc().toString(),
                        style: themeData.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                        children: const [],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // trailing: Text(DateTime.now().toUtc().toString()) ,
          ),
        );
      },
    );
  }
}
