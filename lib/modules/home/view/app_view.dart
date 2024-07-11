import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expensync/app/app.dart';
import 'package:expensync/l10n/l10n.dart';
import 'package:expensync/modules/home/home.dart';
import 'package:expensync/shared/repositories/expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pink,
        primary: Colors.indigo,
      ),
    );
    return BlocListener<ConnectivityCubit, ConnectivityState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        await cubit.onConnection(
          online: state.status == ConnectivityStatus.connected,
        );
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
        theme: theme.copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: theme.colorScheme.inversePrimary.withOpacity(.75),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Provide app-wide blocs and repositories from here.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ExpenseRepo(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AppCubit(expenseRepo: context.read<ExpenseRepo>()),
          ),
          BlocProvider(
            create: (context) =>
                ConnectivityCubit(connectivityRepo: Connectivity()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}
