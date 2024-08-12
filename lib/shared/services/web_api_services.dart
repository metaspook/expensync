import 'dart:convert';
import 'dart:developer';

import 'package:expensync/utils/utils.dart';
import 'package:http/http.dart';

class WebApiService {
  // Singleton pattern prevents other instantiation.
  factory WebApiService() => _instance ??= const WebApiService._();
  const WebApiService._();
  static WebApiService? _instance;

  //-- Configs
  String get smsBaseUrl => 'https://bulksmsbd.net/api/smsapi';
  String get backendUrl => 'http://localhost:6060';

  //-- Public APIs
  Future<StreamedResponse?> requestSms(Map<String, String> body) async {
    try {
      final request = Request('POST', Uri.parse(smsBaseUrl))
        ..body = jsonEncode(body)
        ..headers.addAll(_getHeaders(encoded: false));
      final response = await request.send();
      return _checkStatusCode(response);
    } catch (e, s) {
      log(
        "Couldn't request SMS",
        name: runtimeType.toString(),
        error: e,
        stackTrace: s,
      );
    }
    return null;
  }

  Future<StreamedResponse?> requestDB(
    Map<String, String> body, {
    required ReqType type,
  }) async {
    try {
      final request = Request(type.method, Uri.parse('$backendUrl/api/data'))
        ..body = jsonEncode(body)
        ..headers.addAll({'Content-Type': 'application/json'});
      final response = await request.send();
      return response.statusChecked;
    } catch (e, s) {
      log(
        '${type.method} request failed!',
        name: runtimeType.toString(),
        error: e,
        stackTrace: s,
      );
    }
    return null;
  }

  /// Get basic headers.
  Map<String, String> _getHeaders({bool isGet = false, bool encoded = true}) =>
      {
        if (!isGet)
          'Content-Type':
              'application/${encoded ? 'x-www-form-urlencoded' : 'json'}',
        'Accept': 'application/json',
      };

  /// Check status code and return 'null' if not between 200 to 299.
  StreamedResponse? _checkStatusCode(StreamedResponse response) =>
      (response.statusCode >= 200 && response.statusCode < 300)
          ? response
          : null;
}

enum ReqType {
  upsert('PUT'),
  update('PATCH'),
  delete('DELETE');

  const ReqType(this.method);
  final String method;
}
