import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

LazyDatabase openConnection() => LazyDatabase(
      () async => DatabaseConnection.delayed(
        Future(() async {
          final result = await WasmDatabase.open(
            databaseName: 'db', // prefer to only use valid identifiers here
            sqlite3Uri: Uri.parse('sqlite3.wasm'),
            driftWorkerUri: Uri.parse('drift_worker.dart.js'),
          );
          if (result.missingFeatures.isNotEmpty && kDebugMode) {
            // warning if only unreliable implementations are available.
            log('Using ${result.chosenImplementation} due to missing browser.\nMissing Features: ${result.missingFeatures}');
          }
          return result.resolvedExecutor;
        }),
      ),
    );
