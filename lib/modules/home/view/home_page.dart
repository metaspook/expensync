import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expensync/app/app.dart';
import 'package:expensync/app/cubits/connectivity/connectivity_cubit.dart'
    as bloc;
import 'package:expensync/modules/home/home.dart';
import 'package:expensync/shared/repositories/expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => ExpensesCubit(
            expenseRepo: context.read<ExpenseRepo>(),
            connectivityRepo: context.read<Connectivity>(),
          ),
        ),
      ],
      child: BlocListener<bloc.ConnectivityCubit, bloc.ConnectivityState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) async {
          if (state.status == ConnectivityStatus.connected) {
            await context.read<ExpensesCubit>().syncTable();
          }
        },
        child: const HomeView(),
      ),
    );
  }
}
