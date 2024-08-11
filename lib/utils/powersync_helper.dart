import 'dart:convert';
import 'dart:developer' as dev;

import 'package:expensync/shared/models/models.dart';
import 'package:expensync/utils/utils.dart' as utils;
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';

extension ResponseExt on http.Response {
  /// Check status code and return 'null' if not between 200 to 299.
  http.Response? byStatusCode() =>
      (statusCode >= 200 && statusCode < 300) ? this : null;
}

/// Global reference to the database
late final PowerSyncDatabase db;
final log = Logger('powersync-nodejs');

/// Postgres Response codes that we cannot recover from by retrying.
final List<RegExp> fatalResponseCodes = [
  // Class 22 — Data Exception
  // Examples include data type mismatch.
  RegExp(r'^22...$'),
  // Class 23 — Integrity Constraint Violation.
  // Examples include NOT NULL, FOREIGN KEY and UNIQUE violations.
  RegExp(r'^23...$'),
  // INSUFFICIENT PRIVILEGE - typically a row-level security violation
  RegExp(r'^42501$'),
];

/// Use Custom Node.js backend for authentication and data upload.
class BackendConnector extends PowerSyncBackendConnector {
  BackendConnector(this.db);
  PowerSyncDatabase db;

  Future<void>? _refreshFuture;

  /// Get a token to authenticate against the PowerSync instance.
  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    // final user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   // Not logged in
    //   return null;
    // }
    // final idToken = await user.getIdToken();
    final url = Uri.parse('${utils.AppConfig.backendUrl}/api/auth/token');
    final headers = <String, String>{
      // 'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json', // Adjust content-type if needed
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode case >= 200 && < 300) {
      final body = response.body;
      final jsonMap = jsonDecode(body) as Map?; //parsedBody
      if (jsonMap == null) return null;
      final json = Map<String, dynamic>.from(jsonMap);
      // Use the access token to authenticate against PowerSync
      // userId and expiresAt are for debugging purposes only
      // final expiresAt = json['expiresAt'] == null
      //     ? null
      //     : DateTime.fromMillisecondsSinceEpoch(
      //         (json['expiresAt'] as int) * 1000,
      //       );
      return PowerSyncCredentials(
        endpoint: utils.AppConfig.backendUrl,
        // endpoint: json['powersync_url'] as String,
        // endpoint: json['powerSyncUrl'] as String,
        token: json['token'] as String,
        // userId: json['userId'] as String?,
        // expiresAt: expiresAt,
      );
    } else {
      dev.log('Request failed with status: ${response.statusCode}');
    }
    return null;
  }

  @override
  void invalidateCredentials() {
    // Trigger a session refresh if auth fails on PowerSync.
    // However, in some cases it can be a while before the session refresh is
    // retried. We attempt to trigger the refresh as soon as we get an auth
    // failure on PowerSync.
    //
    // This could happen if the device was offline for a while and the session
    // expired, and nothing else attempt to use the session it in the meantime.
    //
    // Timeout the refresh call to avoid waiting for long retries,
    // and ignore any errors. Errors will surface as expired tokens.
  }

  // Upload pending changes to Node.js Backend.
  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    // This function is called whenever there is data to upload, whether the
    // device is online or offline.
    // If this call throws an error, it is retried periodically.
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) {
      return;
    }

    CrudEntry? lastOp;
    try {
      // Note: If transactional consistency is important, use database functions
      // or edge functions to process the entire transaction in a single call.
      for (final op in transaction.crud) {
        lastOp = op;

        final row = Map<String, dynamic>.of(op.opData!);
        row['id'] = op.id;
        final data = <String, dynamic>{'table': op.table, 'data': row};

        if (op.op == UpdateType.put) {
          await upsert(data);
        } else if (op.op == UpdateType.patch) {
          await update(data);
        } else if (op.op == UpdateType.delete) {
          await delete(data);
        }
      }

      // All operations successful.
      await transaction.complete();
    } catch (e) {
      log.severe('Failed to update object $e');
      transaction.complete();
    }
  }
}

Future<void> upsert(data) async {
  final url = Uri.parse('${utils.AppConfig.backendUrl}/api/data');

  try {
    final response = await http.put(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(data), // Encode data to JSON
    );
    if (response.statusCode == 200) {
      log.info('PUT request successful: ${response.body}');
    } else {
      log.severe('PUT request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    log.severe('Exception occurred: $e');
  }
}

Future<void> update(data) async {
  final url = Uri.parse('${utils.AppConfig.backendUrl}/api/data');

  try {
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json', // Adjust content-type if needed
      },
      body: jsonEncode(data), // Encode data to JSON
    );

    if (response.statusCode == 200) {
      log.info('PUT request successful: ${response.body}');
    } else {
      log.severe('PUT request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    log.severe('Exception occurred: $e');
  }
}

Future<void> delete(data) async {
  final url = Uri.parse('${utils.AppConfig.backendUrl}/api/data');

  try {
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json', // Adjust content-type if needed
      },
      body: jsonEncode(data), // Encode data to JSON
    );

    if (response.statusCode == 200) {
      log.info('DELETE request successful: ${response.body}');
    } else {
      log.severe('DELETE request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    log.severe('Exception occurred: $e');
  }
}

class PowerSyncHelper {
  // Singleton is same instance app-wide.
  factory PowerSyncHelper() => _instance ??= PowerSyncHelper._();
  PowerSyncHelper._();
  static PowerSyncHelper? _instance;

  /// Database path provider.
  Future<String> dbPath() async {
    final dir = await getApplicationSupportDirectory();
    return join(dir.path, 'powersync-demo.db');
  }

  /// logic to get userId
  bool isLoggedIn() {
    return true;
  }

  /// logic to get userId
  String? getUserId() {
    return '';
  }

  /// Open the local database
  Future<void> openDatabase() async {
    // Set up the database
    // Inject the Schema you defined in the previous step and a file path
    db = PowerSyncDatabase(schema: schema, path: await dbPath());
    await db.initialize();
    BackendConnector? currentConnector;

    final userLoggedIn = isLoggedIn();
    if (userLoggedIn) {
      // If the user is already logged in, connect immediately.
      // Otherwise, connect once logged in.
      currentConnector = BackendConnector(db);
      db.connect(connector: currentConnector);
    } else {
      log.info('User not logged in, setting connection');
    }

    // FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (userLoggedIn) {
      // Connect to PowerSync when the user is signed in
      currentConnector = BackendConnector(db);
      db.connect(connector: currentConnector);
    } else {
      currentConnector = null;
      await db.disconnect();
    }
    // });
  }

  /// Explicit sign out - clear database and log out.
  Future<void> logout() async {
    // await FirebaseAuth.instance.signOut();
    await db.disconnectedAndClear();
  }
}
