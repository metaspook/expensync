import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:expensync/shared/services/electric_service.dart';
import 'package:expensync/utils/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart' as hb;
import 'package:path_provider/path_provider.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = true;
  // Electric Sql Service
  await ElectricService()
      .initialize(
        url: 'http://192.168.0.106:5133/',
        dbName: 'expensync',
      )
      .then((client) => client.connect(authToken()));

  hb.HydratedBloc.storage = await hb.HydratedStorage.build(
    storageDirectory: kIsWeb
        ? hb.HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(await builder());
}
