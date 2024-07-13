// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: always_use_package_imports, depend_on_referenced_packages
// ignore_for_file: prefer_double_quotes

import 'package:electricsql/electricsql.dart';

const kSqliteMigrations = <Migration>[
  Migration(
    statements: [
      'CREATE TABLE "expense" (\n  "id" TEXT NOT NULL,\n  "name" TEXT,\n  "amount" REAL NOT NULL,\n  "createdAt" TEXT NOT NULL,\n  "updatedAt" TEXT NOT NULL,\n  CONSTRAINT "expense_pkey" PRIMARY KEY ("id")\n);\n',
      'INSERT OR IGNORE INTO _electric_trigger_settings (namespace, tablename, flag) VALUES (\'main\', \'expense\', 1);',
      'DROP TRIGGER IF EXISTS update_ensure_main_expense_primarykey;',
      'CREATE TRIGGER update_ensure_main_expense_primarykey\n  BEFORE UPDATE ON "main"."expense"\nBEGIN\n  SELECT\n    CASE\n      WHEN old."id" != new."id" THEN\n      		RAISE (ABORT, \'cannot change the value of column id as it belongs to the primary key\')\n    END;\nEND;',
      'DROP TRIGGER IF EXISTS insert_main_expense_into_oplog;',
      'CREATE TRIGGER insert_main_expense_into_oplog\n  AFTER INSERT ON "main"."expense"\n  WHEN 1 = (SELECT flag from _electric_trigger_settings WHERE namespace = \'main\' AND tablename = \'expense\')\nBEGIN\n  INSERT INTO _electric_oplog (namespace, tablename, optype, primaryKey, newRow, oldRow, timestamp)\n  VALUES (\'main\', \'expense\', \'INSERT\', json_patch(\'{}\', json_object(\'id\', new."id")), json_object(\'amount\', cast(new."amount" as TEXT), \'createdAt\', new."createdAt", \'id\', new."id", \'name\', new."name", \'updatedAt\', new."updatedAt"), NULL, NULL);\nEND;',
      'DROP TRIGGER IF EXISTS update_main_expense_into_oplog;',
      'CREATE TRIGGER update_main_expense_into_oplog\n  AFTER UPDATE ON "main"."expense"\n  WHEN 1 = (SELECT flag from _electric_trigger_settings WHERE namespace = \'main\' AND tablename = \'expense\')\nBEGIN\n  INSERT INTO _electric_oplog (namespace, tablename, optype, primaryKey, newRow, oldRow, timestamp)\n  VALUES (\'main\', \'expense\', \'UPDATE\', json_patch(\'{}\', json_object(\'id\', new."id")), json_object(\'amount\', cast(new."amount" as TEXT), \'createdAt\', new."createdAt", \'id\', new."id", \'name\', new."name", \'updatedAt\', new."updatedAt"), json_object(\'amount\', cast(old."amount" as TEXT), \'createdAt\', old."createdAt", \'id\', old."id", \'name\', old."name", \'updatedAt\', old."updatedAt"), NULL);\nEND;',
      'DROP TRIGGER IF EXISTS delete_main_expense_into_oplog;',
      'CREATE TRIGGER delete_main_expense_into_oplog\n  AFTER DELETE ON "main"."expense"\n  WHEN 1 = (SELECT flag from _electric_trigger_settings WHERE namespace = \'main\' AND tablename = \'expense\')\nBEGIN\n  INSERT INTO _electric_oplog (namespace, tablename, optype, primaryKey, newRow, oldRow, timestamp)\n  VALUES (\'main\', \'expense\', \'DELETE\', json_patch(\'{}\', json_object(\'id\', old."id")), NULL, json_object(\'amount\', cast(old."amount" as TEXT), \'createdAt\', old."createdAt", \'id\', old."id", \'name\', old."name", \'updatedAt\', old."updatedAt"), NULL);\nEND;',
    ],
    version: '20240713123905',
  )
];
