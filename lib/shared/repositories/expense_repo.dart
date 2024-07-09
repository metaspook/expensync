import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:expensync/shared/models/models.dart';
import 'package:expensync/utils/utils.dart';

enum CrudType { create, delete, update, read }

extension RealtimeMessageExt on RealtimeMessage {
  String get crudEvent => events.first.split('.').last;
}

class ExpenseRepo {
  // TodoRepo() {
  //   _todoListController.add([]);
  // }
  CrudType? _crudType;
  String? _realtimeEvent;
  RealtimeSubscription? _realtimeSubscription;
  final _realtime = AppWriteHelper().realtime;

  final _expensesController = StreamController<List<Expense>>.broadcast();
  Stream<List<Expense>> get expensesStream => _expensesController.stream;
  // Future<List<Todo>> get todoList => _todoListController.stream.first;

  Future<void> init() async {
    final cachedTodoList = <Expense>[];

    Future<void> firstInit() async {
      try {
        final res = await AppWriteHelper().databases.listDocuments(
              collectionId: AppWriteHelper.collectionId,
              databaseId: AppWriteHelper.databaseId,
            );
        cachedTodoList.clear();
        for (final doc in res.documents) {
          print('HERE: ${doc.data}');

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
          cachedTodoList.add(expense);
        }

        _expensesController.add(cachedTodoList);
      } on AppwriteException catch (e) {
        print(e.message);
      }
    }

    // First time init
    await firstInit();
    const channels = [
      'databases.${AppWriteHelper.databaseId}.collections.${AppWriteHelper.collectionId}.documents',
    ];
    // Subscription
    try {
      _realtimeSubscription = _realtime.subscribe(channels)
        ..stream.listen((data) async {
          print('EVENT::: ${data.crudEvent}');
          await firstInit();
        });
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  Future<bool> create(Expense expense) async {
    final dateTimeStr = AppUtils.dateTimeStr;
    final expenseJsonStr = jsonEncode({
      'name': expense.name,
      'amount': expense.amount,
      'createdAt': expense.createdAt,
      'updatedAt': expense.updatedAt,
    });
    try {
      // final document = await AppWriteHelper().databases.createDocument(
      AppWriteHelper().databases
        ..createDocument(
          databaseId: ID.custom(AppWriteHelper.databaseId),
          collectionId: ID.custom(
            AppWriteHelper.collectionId,
          ), //change your collection id
          documentId: expense.id,
          data: {'expense': expenseJsonStr},
          permissions: [
            Permission.read(Role.any()),
            Permission.write(Role.any()),
          ],
        ).then((_) {
          _crudType = CrudType.create;
          print('HILL::');
          return true;
        });

      // print(document.toMap());
      // emit(state.copyWith(status: TodosStatus.success));
    } on AppwriteException catch (e) {
      print(e.message);
    }
    return false;
  }

  Future<bool> delete(String expenseId) async {
    // final todoList = await todoListStream.first;
    try {
      await AppWriteHelper()
          .databases
          .deleteDocument(
            databaseId: ID.custom(AppWriteHelper.databaseId),
            collectionId: ID.custom(AppWriteHelper.collectionId),
            documentId: expenseId,
          )
          .then((_) {
        // cachedTodoList.remove(value)
        _crudType = CrudType.delete;
        return true;
      });
      // return true;
    } on AppwriteException catch (e) {
      print(e.message);
    }
    return false;
  }

  Future<bool> update(Expense expense) async {
    final expenseJsonStr = jsonEncode({
      'name': expense.name,
      'createdAt': expense.createdAt,
      'updatedAt': expense.updatedAt,
    });
    try {
      // final document = await AppWriteHelper().databases.createDocument(
      await AppWriteHelper().databases.updateDocument(
        databaseId: ID.custom(AppWriteHelper.databaseId),
        collectionId: ID.custom(
          AppWriteHelper.collectionId,
        ),
        documentId: expense.id,
        data: {'expense': expenseJsonStr},
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.any()),
        ],
      ).then((_) {
        _crudType = CrudType.update;
        return true;
      });

      // print(document.toMap());
      // emit(state.copyWith(status: TodosStatus.success));
    } on AppwriteException catch (e) {
      print(e.message);
    }
    return false;
  }

  void dispose() {
    _realtimeSubscription?.close();
    _expensesController.close();
  }
}
