import 'package:drift/drift.dart';
import 'package:electricsql/drivers/drift.dart';
import 'package:expensync/generated/electric/drift_schema.dart';
import 'package:expensync/shared/services/connections/native.dart'
    if (dart.library.html) 'connections/web.dart' as multi_platform;

part 'database.g.dart';

@DriftDatabase(tables: kElectrifiedTables)
class AppDatabase extends _$AppDatabase {
  factory AppDatabase() => _instance ??= AppDatabase._();
  AppDatabase._() : super(_openConnection());
  static AppDatabase? _instance;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {},
    );
  }
}

QueryExecutor _openConnection() {
  return multi_platform.connectOn();
}
