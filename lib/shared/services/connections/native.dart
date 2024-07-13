import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

LazyDatabase openConnection() => LazyDatabase(
      () async {
        // putting database file 'db.sqlite' into the documents folder.
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'db.sqlite'));
        if (Platform.isAndroid) {
          // workaround for old Android versions.
          await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
          // workaround for sqlite3's default trying dir '/tmp' inaccessible on Android.
        }
        sqlite3.tempDirectory = (await getTemporaryDirectory()).path;
        return NativeDatabase.createInBackground(file);
      },
    );
