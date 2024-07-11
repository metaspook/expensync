// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: always_use_package_imports, depend_on_referenced_packages
// ignore_for_file: prefer_double_quotes

import 'package:drift/drift.dart';
import 'package:electricsql/drivers/drift.dart';
import 'package:electricsql/electricsql.dart';

import './migrations.dart';
import './pg_migrations.dart';

const kElectricMigrations = ElectricMigrations(
  sqliteMigrations: kSqliteMigrations,
  pgMigrations: kPostgresMigrations,
);
const kElectrifiedTables = [Expense];

class Expense extends Table {
  TextColumn get id => text().named('id')();

  TextColumn get name => text().named('name').nullable()();

  RealColumn get amount => customType(ElectricTypes.float8).named('amount')();

  Column<DateTime> get createdAt =>
      customType(ElectricTypes.timestampTZ).named('createdAt')();

  Column<DateTime> get updatedAt =>
      customType(ElectricTypes.timestampTZ).named('updatedAt')();

  @override
  String? get tableName => 'expense';

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
