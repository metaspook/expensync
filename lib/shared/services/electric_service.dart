import 'dart:async';
import 'dart:developer';

import 'package:electricsql_flutter/drivers/drift.dart';
import 'package:electricsql_flutter/electricsql_flutter.dart';
import 'package:expensync/generated/electric/drift_schema.dart';
import 'package:expensync/shared/services/database.dart';
import 'package:flutter/foundation.dart';

/// {@template electric}
/// Service provider of electric-sql.
/// {@endtemplate}
class ElectricService {
  /// {@macro electric}
  /// * Lazy Singleton of Electric Service.
  factory ElectricService() => _instance ??= ElectricService._();
  ElectricService._();
  final AppDatabase _database = AppDatabase();
  late final ElectricClient<AppDatabase> _client;
  ElectricClient<AppDatabase> get client {
    try {
      return _client;
    } catch (_) {
      throw Exception('ElectricClient is uninitialized!');
    }
  }

  static ElectricService? _instance;

  // Getter to access the singleton instance
  Future<ElectricClient<AppDatabase>> initialize({
    required String url,
    required String dbName,
  }) async {
    if (kDebugMode) log('Electrifying DB at $url');
    return _client = await electrify<AppDatabase>(
      dbName: dbName,
      db: _database,
      migrations: kElectricMigrations,
      config: ElectricConfig(
        url: url,
        logger:
            kDebugMode ? LoggerConfig(level: Level.debug, colored: true) : null,
      ),
    ).then((_) {
      if (kDebugMode) log('Electrifying DB at $url', name: 'ElectricService');
      return _;
    });
  }

  // Future<void> connect() async {
  //   try {
  //     await electricClient.connect(authToken()).whenComplete(() {
  //       if (kDebugMode) {
  //         print('Electric client connect successfully');
  //       }
  //     });
  //   } on SatelliteException catch (e) {
  //     if (kDebugMode) {
  //       print(e.message);
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  // void disconnect() {
  //   electricClient.disconnect();
  //   if (kDebugMode) {
  //     print('Electric client disconnected!');
  //   }
  // }
}
