import 'package:expensync/app/app.dart';
import 'package:expensync/modules/home/home.dart';
import 'package:expensync/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final cubit = context.read<HomeCubit>();
    final expensesCubit = context.read<ExpensesCubit>();
    final appCubit = context.read<AppCubit>();
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
                        BlocListener<ExpensesCubit, ExpensesState>(
                          listener: (context, state) {
                            final statusMsg = state.statusMsg;
                            if (statusMsg != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(statusMsg)),
                              );
                            }
                          },
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: selectionEnabled
                                ? () => expensesCubit.removeAllSelectedExpense(
                                      tasker: appCubit.doTask,
                                    )
                                : null,
                            icon: const Icon(Icons.delete_forever_rounded),
                          ),
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
                  preferredSize: const Size.fromHeight(kToolbarHeight * .84),
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
                        const SizedBox(width: 1),
                        BlocSelector<AppCubit, AppState, SyncStatus>(
                          selector: (state) => state.syncStatus,
                          builder: (context, syncStatus) {
                            return Row(
                              children: [
                                // Offline
                                [
                                  const Icon(
                                    Icons.sync_problem_rounded,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Offline',
                                    style: themeData.textTheme.titleMedium,
                                  ),
                                ],
                                // Online
                                [
                                  const Icon(
                                    Icons.wifi_rounded,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Online',
                                    style: themeData.textTheme.titleMedium,
                                  ),
                                ],
                                // Syncing
                                [
                                  StreamBuilder<double>(
                                    stream: Stream.periodic(
                                      Durations.extralong4 * 2,
                                      (count) => count.toDouble(),
                                    ),
                                    builder: (context, snapshot) {
                                      return AnimatedRotation(
                                        duration: Durations.extralong4,
                                        turns: snapshot.data ?? 0,
                                        child: const Icon(
                                          Icons.sync_outlined,
                                          color: Colors.amber,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Syncing...',
                                    style: themeData.textTheme.titleMedium,
                                  ),
                                ],
                              ][syncStatus.index..doPrint()],
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
                            BlocSelector<AppCubit, AppState, int>(
                              selector: (state) => state.tasks.length,
                              builder: (context, tasksLength) {
                                return Text(
                                  tasksLength.toString(),
                                  style: themeData.textTheme.labelMedium
                                      ?.copyWith(color: Colors.blue),
                                );
                              },
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
