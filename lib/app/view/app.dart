import 'package:expensync/l10n/l10n.dart';
import 'package:expensync/modules/home/home.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(seedColor: Colors.pink, primary: Colors.indigo),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: theme.colorScheme.inversePrimary.withOpacity(.75),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
              bottom: Radius.circular(15),
            ),
          ),
        ),
      ),

      // ThemeData(
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   ),
      //   useMaterial3: true,
      // ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
