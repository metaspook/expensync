// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: always_use_package_imports, depend_on_referenced_packages
// ignore_for_file: prefer_double_quotes

import 'package:electricsql/electricsql.dart';

const kPostgresMigrations = <Migration>[
  Migration(
    statements: [
      'CREATE TABLE expense (\n    id text NOT NULL,\n    name text,\n    amount double precision NOT NULL,\n    "createdAt" timestamp with time zone NOT NULL,\n    "updatedAt" timestamp with time zone NOT NULL,\n    CONSTRAINT expense_pkey PRIMARY KEY (id)\n)',
      'INSERT INTO "public"."_electric_trigger_settings" ("namespace", "tablename", "flag")\nVALUES (\'public\', \'expense\', 1)\nON CONFLICT DO NOTHING;\n',
      'DROP TRIGGER IF EXISTS update_ensure_public_expense_primarykey ON "public"."expense";',
      '        CREATE OR REPLACE FUNCTION update_ensure_public_expense_primarykey_function()\n        RETURNS TRIGGER AS \$\$\n        BEGIN\n          IF OLD."id" IS DISTINCT FROM NEW."id" THEN\n            RAISE EXCEPTION \'Cannot change the value of column id as it belongs to the primary key\';\n          END IF;\n          RETURN NEW;\n        END;\n        \$\$ LANGUAGE plpgsql;\n      ',
      '        CREATE TRIGGER update_ensure_public_expense_primarykey\n          BEFORE UPDATE ON "public"."expense"\n            FOR EACH ROW\n              EXECUTE FUNCTION update_ensure_public_expense_primarykey_function();\n      ',
      'DROP TRIGGER IF EXISTS insert_public_expense_into_oplog ON "public"."expense";',
      '        CREATE OR REPLACE FUNCTION insert_public_expense_into_oplog_function()\n        RETURNS TRIGGER AS \$\$\n        BEGIN\n          DECLARE\n            flag_value INTEGER;\n          BEGIN\n            -- Get the flag value from _electric_trigger_settings\n            SELECT flag INTO flag_value FROM "public"._electric_trigger_settings WHERE namespace = \'public\' AND tablename = \'expense\';\n    \n            IF flag_value = 1 THEN\n              -- Insert into _electric_oplog\n              INSERT INTO "public"._electric_oplog (namespace, tablename, optype, "primaryKey", "newRow", "oldRow", timestamp)\n              VALUES (\n                \'public\',\n                \'expense\',\n                \'INSERT\',\n                json_strip_nulls(json_build_object(\'id\', new."id")),\n                jsonb_build_object(\'amount\', cast(new."amount" as TEXT), \'createdAt\', new."createdAt", \'id\', new."id", \'name\', new."name", \'updatedAt\', new."updatedAt"),\n                NULL,\n                NULL\n              );\n            END IF;\n    \n            RETURN NEW;\n          END;\n        END;\n        \$\$ LANGUAGE plpgsql;\n      ',
      '        CREATE TRIGGER insert_public_expense_into_oplog\n          AFTER INSERT ON "public"."expense"\n            FOR EACH ROW\n              EXECUTE FUNCTION insert_public_expense_into_oplog_function();\n      ',
      'DROP TRIGGER IF EXISTS update_public_expense_into_oplog ON "public"."expense";',
      '        CREATE OR REPLACE FUNCTION update_public_expense_into_oplog_function()\n        RETURNS TRIGGER AS \$\$\n        BEGIN\n          DECLARE\n            flag_value INTEGER;\n          BEGIN\n            -- Get the flag value from _electric_trigger_settings\n            SELECT flag INTO flag_value FROM "public"._electric_trigger_settings WHERE namespace = \'public\' AND tablename = \'expense\';\n    \n            IF flag_value = 1 THEN\n              -- Insert into _electric_oplog\n              INSERT INTO "public"._electric_oplog (namespace, tablename, optype, "primaryKey", "newRow", "oldRow", timestamp)\n              VALUES (\n                \'public\',\n                \'expense\',\n                \'UPDATE\',\n                json_strip_nulls(json_build_object(\'id\', new."id")),\n                jsonb_build_object(\'amount\', cast(new."amount" as TEXT), \'createdAt\', new."createdAt", \'id\', new."id", \'name\', new."name", \'updatedAt\', new."updatedAt"),\n                jsonb_build_object(\'amount\', cast(old."amount" as TEXT), \'createdAt\', old."createdAt", \'id\', old."id", \'name\', old."name", \'updatedAt\', old."updatedAt"),\n                NULL\n              );\n            END IF;\n    \n            RETURN NEW;\n          END;\n        END;\n        \$\$ LANGUAGE plpgsql;\n      ',
      '        CREATE TRIGGER update_public_expense_into_oplog\n          AFTER UPDATE ON "public"."expense"\n            FOR EACH ROW\n              EXECUTE FUNCTION update_public_expense_into_oplog_function();\n      ',
      'DROP TRIGGER IF EXISTS delete_public_expense_into_oplog ON "public"."expense";',
      '        CREATE OR REPLACE FUNCTION delete_public_expense_into_oplog_function()\n        RETURNS TRIGGER AS \$\$\n        BEGIN\n          DECLARE\n            flag_value INTEGER;\n          BEGIN\n            -- Get the flag value from _electric_trigger_settings\n            SELECT flag INTO flag_value FROM "public"._electric_trigger_settings WHERE namespace = \'public\' AND tablename = \'expense\';\n    \n            IF flag_value = 1 THEN\n              -- Insert into _electric_oplog\n              INSERT INTO "public"._electric_oplog (namespace, tablename, optype, "primaryKey", "newRow", "oldRow", timestamp)\n              VALUES (\n                \'public\',\n                \'expense\',\n                \'DELETE\',\n                json_strip_nulls(json_build_object(\'id\', old."id")),\n                NULL,\n                jsonb_build_object(\'amount\', cast(old."amount" as TEXT), \'createdAt\', old."createdAt", \'id\', old."id", \'name\', old."name", \'updatedAt\', old."updatedAt"),\n                NULL\n              );\n            END IF;\n    \n            RETURN NEW;\n          END;\n        END;\n        \$\$ LANGUAGE plpgsql;\n      ',
      '        CREATE TRIGGER delete_public_expense_into_oplog\n          AFTER DELETE ON "public"."expense"\n            FOR EACH ROW\n              EXECUTE FUNCTION delete_public_expense_into_oplog_function();\n      ',
    ],
    version: '20240713123905',
  )
];
