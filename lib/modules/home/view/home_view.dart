import 'package:expensync/modules/home/expense_entry/view/expense_entry_view.dart';
import 'package:expensync/modules/home/expense_report/view/expense_report_view.dart';
import 'package:expensync/modules/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final cubit = context.read<HomeCubit>();
    // final appCubit = context.read<AppCubit>();
    // final repo = context.read<TodoRepo>();

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
      bottomNavigationBar: BlocSelector<HomeCubit, HomeState, int>(
        selector: (state) => state.tabIndex,
        builder: (context, tabIndex) {
          return BottomNavigationBar(
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
    );
  }
}
