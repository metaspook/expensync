import 'dart:async';

import 'package:electricsql/util.dart';
import 'package:electricsql_flutter/drivers/drift.dart';
import 'package:electricsql_flutter/electricsql_flutter.dart';
import 'package:expensync/generated/electric/drift_schema.dart';
import 'package:expensync/shared/services/database.dart';
import 'package:expensync/utils/auth.dart';
import 'package:flutter/foundation.dart';

class ElectricService {
  ElectricService._();
  final AppDatabase _database = AppDatabase();
  final String _databaseName = 'electric_todo';
  final String _electricURL = 'http://192.168.0.105:5133/';
  late ElectricClient<AppDatabase>? electricClient;

  // Singleton instance variable
  static final ElectricService _instance = ElectricService._();

  // Getter to access the singleton instance
  static ElectricService get instance => _instance;

  Future<ElectricClient<AppDatabase>?> startElectricDrift() async {
    if (kDebugMode) {
      print('Electrifying database...');
      print('Electric URL: $_electricURL');
    }
    try {
      return await electrify<AppDatabase>(
        dbName: _databaseName,
        db: _database,
        migrations: kElectricMigrations,
        config: ElectricConfig(
          url: _electricURL,
          logger: LoggerConfig(level: Level.debug, colored: true),
        ),
      ).whenComplete(() {
        if (kDebugMode) {
          print('Electrify client create!');
        }
      });
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Database electrified Error: $e');
      }
    }
    return null;
  }

  Future<void> connect() async {
    try {
      await electricClient?.connect(authToken()).whenComplete(() {
        if (kDebugMode) {
          print('Electric client connect successfully');
        }
      });
    } on SatelliteException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void disconnect() {
    electricClient?.disconnect();
    if (kDebugMode) {
      print('Electric client disconnected!');
    }
  }
}
