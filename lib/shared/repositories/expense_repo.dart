import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:expensync/shared/models/models.dart';
import 'package:expensync/utils/utils.dart';

class ExpenseRepo implements CRUD<Json, Expense> {
  void dispose() {
    _realtimeSubscription?.close();
    _expensesController.close();
  }

  //-- Config
  final _cacheExpenses = <Expense>[];
  final _channels = const [
    'databases.${AppWriteHelper.databaseId}.collections.${AppWriteHelper.collectionId}.documents',
  ];

  RealtimeSubscription? _realtimeSubscription;

  final _expensesController = StreamController<List<Expense>>.broadcast();
  Stream<List<Expense>> get expenses2Stream => _expensesController.stream;

  final _db = AppWriteHelper().databases;
  final _realtime = AppWriteHelper().realtime;
  final _errorMsgNotFound = 'Expenses not found!';
  final _errorMsg = "Couldn't get the Expenses!";
  final _errorMsgCreate = "Couldn't create the Expense!";
  final _errorMsgRead = "Couldn't read the Expense data!";
  final _errorMsgUpdate = "Couldn't update the Expenses!";
  final _errorMsgDelete = "Couldn't delete the Expenses!";

  Future<(String?, List<Expense>)> readAll() async {
    try {
      final res = await _db.listDocuments(
        collectionId: AppWriteHelper.collectionId,
        databaseId: AppWriteHelper.databaseId,
      );
      _cacheExpenses.clear();
      for (final doc in res.documents) {
        final docMap = Map<String, Object?>.from(
          jsonDecode(doc.data['expense'] as String) as Map,
        );
        final expense = Expense.fromJson({
          r'$id': doc.data[r'$id'],
          'name': docMap['name'],
          'amount': docMap['amount'],
          'createdAt': docMap['createdAt'],
          'updatedAt': docMap['updatedAt'],
        });
        _cacheExpenses.add(expense);
      }
    } on AppwriteException catch (e, s) {
      log(_errorMsgNotFound, error: e, stackTrace: s);
      return (_errorMsgNotFound, _cacheExpenses);
    }
    return (null, _cacheExpenses);
  }

  Stream<List<Expense>> get streamList async* {
    final (errorMsg, expenses) = await readAll();
    if (errorMsg != null) {
      yield expenses;
    }
    _realtime.subscribe(_channels).stream.listen((data) {
      final expenseMap = jsonDecode(data.payload['expense'] as String) as Map;
      expenseMap.doPrint('EXPENSEMAP: ');
    });
  }

  // void subscribe() {
  //   // Subscription
  //   try {
  //     _realtimeSubscription?.close();
  //     _realtimeSubscription = _realtime.subscribe(_channels)
  //       ..stream.listen((data) async {
  //         data.crudEvent.doPrint('EVENT::: ');
  //         _cacheExpenses.doPrint('EXPENSES CACHE: ');

  //         if (data.crudEvent == AppWriteCrudEvent.update) {
  //           'Updated : ${data.payload}'.doPrint();
  //           '${data.payload['expense']}'.doPrint('REMOTE UPDATED OBJ: ');

  //           for (final cachedExpense in _cacheExpenses) {
  //             if (cachedExpense.id == data.payload[r'$id']) {
  //               'Exist in Local'.doPrint();
  //               final dateTime1 = DateTime.parse(cachedExpense.updatedAt);
  //               final dateTime2 = DateTime.parse(
  //                 (jsonDecode(data.payload['expense'] as String)
  //                     as Map)['updatedAt'] as String,
  //               );
  //               if (dateTime1.compareTo(dateTime2) > 0) {
  //                 'Local is Latest'.doPrint();
  //               }
  //               break;
  //             }
  //           }
  //         }

  //         await readAll();
  //       });
  //   } on AppwriteException catch (e) {
  //     print(e.message);
  //   }
  // }

  @override
  Future<String?> create(String id, {required Json value}) async {
    try {
      await _db.createDocument(
        databaseId: ID.custom(AppWriteHelper.databaseId),
        collectionId: ID.custom(AppWriteHelper.collectionId),
        documentId: id,
        permissions: AppWriteHelper.permissions,
        data: {'expense': jsonEncode(value)},
      );
    } on AppwriteException catch (e, s) {
      log(_errorMsgCreate, error: e, stackTrace: s);
      return _errorMsgCreate;
    }
    return null;
  }

  @override
  Future<String?> delete(String id) async {
    try {
      await _db.deleteDocument(
        databaseId: ID.custom(AppWriteHelper.databaseId),
        collectionId: ID.custom(AppWriteHelper.collectionId),
        documentId: id,
      );
    } on AppwriteException catch (e, s) {
      log(_errorMsgDelete, error: e, stackTrace: s);
      return _errorMsgDelete;
    }
    return null;
  }

  @override
  Future<String?> update(String id, {required Json value}) async {
    try {
      await _db.updateDocument(
        databaseId: ID.custom(AppWriteHelper.databaseId),
        collectionId: ID.custom(AppWriteHelper.collectionId),
        documentId: id,
        permissions: AppWriteHelper.permissions,
        data: {'expense': jsonEncode(value)},
      );
    } on AppwriteException catch (e, s) {
      log(_errorMsgUpdate, error: e, stackTrace: s);
      return _errorMsgUpdate;
    }
    return null;
  }

  @override
  Future<(String?, Expense)> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }
}
