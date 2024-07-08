import 'package:expensync/modules/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final cubit = context.read<HomeCubit>();
    final expensesCubit = context.read<ExpensesCubit>();
    // final appCubit = context.read<AppCubit>();
    // final repo = context.read<TodoRepo>();
    final selectionEnabled =
        context.select((ExpensesCubit cubit) => cubit.state.selectionEnabled);

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expensync',
                      style: themeData.textTheme.titleLarge,
                    ),
                    Text(
                      'Minimal Expense Manager',
                      style: themeData.textTheme.titleSmall?.copyWith(
                        color: themeData.textTheme.titleSmall?.color
                            ?.withOpacity(.5),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // if (online)
                    const Icon(
                      Icons.wifi_rounded,
                      color: Colors.green,
                    ),
                    // else
                    // Icon(
                    //   Icons.wifi_off_rounded,
                    //   color: Colors.red,
                    // ),
                    const SizedBox(width: 10),
                    Text(
                      'Connection',
                      style: themeData.textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: selectionEnabled
                          ? expensesCubit.removeAllSelectedExpense
                          : null,
                      icon: const Icon(Icons.delete_forever_rounded),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed:
                          selectionEnabled ? expensesCubit.deselectAll : null,
                      icon: const Icon(Icons.deselect),
                    ),
                  ],
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sync status: ',
                      style: themeData.textTheme.titleMedium,
                    ),
                    Row(
                      children: [
                        Text.rich(
                          style: themeData.textTheme.titleLarge
                              ?.copyWith(color: Colors.blue),
                          TextSpan(
                            text: '0',
                            children: [
                              TextSpan(
                                text: ' Pending',
                                style:
                                    themeData.textTheme.titleMedium?.copyWith(
                                  color: themeData.textTheme.titleMedium?.color,
                                ),
                                children: const [],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text.rich(
                          style: themeData.textTheme.titleLarge
                              ?.copyWith(color: Colors.blue),
                          TextSpan(
                            text: '0',
                            children: [
                              TextSpan(
                                text: ' Items',
                                style:
                                    themeData.textTheme.titleMedium?.copyWith(
                                  color: themeData.textTheme.titleMedium?.color,
                                ),
                                children: const [],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: BlocSelector<HomeCubit, HomeState, int>(
          selector: (state) => state.tabIndex,
          builder: (context, tabIndex) {
            return [
              const ExpensesView(),
              const ExpenseEntryView(),
              const ExpenseReportView(),
            ][tabIndex];
          },
        ),
      ),
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        clipBehavior: Clip.hardEdge,
        child: BlocSelector<HomeCubit, HomeState, int>(
          selector: (state) => state.tabIndex,
          builder: (context, tabIndex) {
            return BottomNavigationBar(
              backgroundColor:
                  themeData.colorScheme.inversePrimary.withOpacity(.875),
              currentIndex: tabIndex,
              onTap: (index) {
                if (index != tabIndex) cubit.changeTab(index);
              },
              items: const [
                BottomNavigationBarItem(
                  label: 'Expenses',
                  icon: Icon(Icons.library_books_rounded),
                ),
                BottomNavigationBarItem(
                  label: 'Add Entry',
                  icon: Icon(Icons.library_add_rounded),
                ),
                BottomNavigationBarItem(
                  label: 'Report',
                  icon: Icon(Icons.receipt_outlined),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
