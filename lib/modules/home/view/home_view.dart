import 'package:expensync/app/app.dart';
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
          BlocSelector<HomeCubit, HomeState, int>(
            selector: (state) => state.tabIndex,
            builder: (context, tabIndex) {
              return SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                actions: [
                  if (tabIndex == 0)
                    Row(
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
                          onPressed: selectionEnabled
                              ? expensesCubit.deselectAll
                              : null,
                          icon: const Icon(Icons.deselect),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                ],
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
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 7.5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status: ',
                          style: themeData.textTheme.titleMedium,
                        ),
                        const SizedBox(width: 5),
                        BlocSelector<AppCubit, AppState, bool>(
                          selector: (state) => state.online,
                          builder: (context, online) {
                            return Row(
                              children: [
                                if (online)
                                  const Icon(
                                    Icons.sync_outlined,
                                    color: Colors.green,
                                  )
                                else
                                  const Icon(
                                    Icons.sync_problem_rounded,
                                    color: Colors.red,
                                  ),
                                const SizedBox(width: 5),
                                Text(
                                  'Syncing...',
                                  style: themeData.textTheme.titleMedium,
                                ),
                              ],
                            );
                          },
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              'Pending:',
                              style: themeData.textTheme.labelMedium,
                            ),
                            Text(
                              '0',
                              style: themeData.textTheme.labelMedium
                                  ?.copyWith(color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
