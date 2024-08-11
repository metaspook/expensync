import 'package:appwrite/appwrite.dart';

class AppWriteHelper {
  factory AppWriteHelper() => _instance ??= AppWriteHelper._();
  AppWriteHelper._();
  static AppWriteHelper? _instance;

  static const endpoint = 'https://192.168.0.106/v1';
  static const projectId = '66892476003087d25c70';
  static const databaseId = '668925090008882be343';
  static const collectionId = '66892528003d8ac1fb5e';

  // static const endpoint = 'https://192.168.1.91/v1';
  // static const projectId = '66857df3002e3cf1fb27';
  // static const databaseId = '668583f20029a4ccedc4';
  // static const collectionId = '6685844d00274f2cfb73';

  late final Client client;
  late final Account account;
  late final Storage storage;
  late final Databases databases;
  late final Realtime realtime;
}
