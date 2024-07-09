import 'package:appwrite/appwrite.dart';

class AppWriteHelper {
  factory AppWriteHelper() => _instance ??= AppWriteHelper._();
  AppWriteHelper._();

  static AppWriteHelper? _instance;

  static const endpoint = 'https://192.168.0.105/v1';
  static const projectId = '668ccc81003d9867a4e7';
  static const databaseId = '668ccd1b0014ff5dfe9d';
  static const collectionId = '668ccd330033e90a2dfb';

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
