import 'package:drift/drift.dart';
import 'package:electricsql/drivers/drift.dart';
import 'package:expensync/generated/electric/drift_schema.dart';
import 'package:expensync/shared/services/connections/native.dart'
    if (dart.library.html) 'connections/web.dart' as multi_platform;

part 'database.g.dart';

@DriftDatabase(tables: kElectrifiedTables)
class AppDatabase extends _$AppDatabase {
  factory AppDatabase() => _instance ??= AppDatabase._();
  AppDatabase._() : super(multi_platform.openConnection());
  static AppDatabase? _instance;

  @override
  int get schemaVersion => 1;

  // empty callback to prevent drift from creating the tables in the local
  // database, as this is done automatically by Electric.
  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (_) async {});
}
