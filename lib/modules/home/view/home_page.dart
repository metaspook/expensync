import 'package:expensync/modules/home/home.dart';
import 'package:expensync/shared/repositories/todo_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodoRepo(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeCubit(),
          ),
          BlocProvider(
            create: (context) =>
                ExpensesCubit(todoRepo: context.read<TodoRepo>()),
          ),
        ],
        child: const HomeView(),
      ),
    );
  }
}
