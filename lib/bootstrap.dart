import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';
import 'package:expensync/utils/utils.dart';
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
  hb.HydratedBloc.storage = await hb.HydratedStorage.build(
    storageDirectory: kIsWeb
        ? hb.HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  final client = Client();
  AppWriteHelper().account = Account(client);
  AppWriteHelper().storage = Storage(client);
  AppWriteHelper().databases = Databases(client);
  AppWriteHelper().realtime = Realtime(client);
  AppWriteHelper().client = client
      .setEndpoint(AppWriteHelper.endpoint) // Your Appwrite Endpoint
      .setProject(AppWriteHelper.projectId) // Your project ID
      .setSelfSigned(); // Use only on dev mode with a self-signed SSL cert

  runApp(await builder());
}
