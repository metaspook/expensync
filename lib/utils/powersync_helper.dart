import 'dart:convert';
import 'dart:developer';

import 'package:expensync/shared/models/models.dart';
import 'package:expensync/utils/utils.dart' as utils;
import 'package:expensync/utils/utils.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';

final logger = Logger('powersync-nodejs');

/// Use Custom Node.js backend for authentication and data upload.
class BackendConnector extends PowerSyncBackendConnector {
  BackendConnector(this.db);
  PowerSyncDatabase db;

  PowerSyncCredentials? _parseCredentials(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    return PowerSyncCredentials(
      endpoint: utils.AppConfig.powersyncUrl,
      token: json['token'] as String,
    );
  }

  Future<StreamedResponse?> _requestCredentials() async {
    try {
      final url = Uri.parse('${utils.AppConfig.backendUrl}/api/auth/token');
      final request = Request('GET', url)
        ..headers.addAll({'Content-Type': 'application/json'});
      final response = await request.send();
      return response.statusChecked;
    } catch (e, s) {
      log(
        'Credentials request failed!',
        name: runtimeType.toString(),
        error: e,
        stackTrace: s,
      );
    }
    return null;
  }

  /// Get a token to authenticate against the PowerSync instance.
  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    final response = await _requestCredentials();
    if (response == null) return null;
    final bodyStr = await response.stream.bytesToString();
    return _parseCredentials(bodyStr)..doPrint();
  }

  // Upload pending changes to Node.js Backend.
  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getNextCrudTransaction();
    if (transaction != null) {
      try {
        // Note: In transactional consistency, use database/edge functions to process the entire transaction in a single call.
        for (final entry in transaction.crud) {
          final row = {
            if (entry.op != UpdateType.delete) ...?entry.opData,
            'id': entry.id,
          };
          final data = {'table': entry.table, 'data': row};
          await PowerSyncHelper().requestDB(data, type: entry.op);
        }
      } catch (e) {
        logger.severe('Failed to update object $e');
      } finally {
        // All operations successful.
        await transaction.complete();
      }
    }
  }
}

class PowerSyncHelper {
  // Singleton is same instance app-wide.
  factory PowerSyncHelper() => _instance ??= PowerSyncHelper._();
  PowerSyncHelper._();
  static PowerSyncHelper? _instance;

  /// Global reference to the database
  late final PowerSyncDatabase db;

  /// Database path provider.
  Future<String> dbPath() async {
    final dir = await getApplicationSupportDirectory();
    return join(dir.path, 'powersync-demo.db');
  }

  /// Open the local database
  Future<void> openDatabase() async {
    db = PowerSyncDatabase(schema: schema, path: await dbPath());
    await db.initialize().then(
          (_) => db.connect(
            connector: BackendConnector(db),
            crudThrottleTime: const Duration(seconds: 2),
          ),
        );
  }

  Future<StreamedResponse?> requestDB(
    Map<String, dynamic> body, {
    required UpdateType type,
  }) async {
    try {
      final request = Request(
        type.json,
        Uri.parse('${AppConfig.backendUrl}/api/data'),
      )
        ..body = jsonEncode(body)
        ..headers.addAll({'Content-Type': 'application/json'});
      final response = await request.send();
      return response.statusChecked;
    } catch (e, s) {
      log(
        '${type.json} request failed!',
        name: runtimeType.toString(),
        error: e,
        stackTrace: s,
      );
    }
    return null;
  }
}
