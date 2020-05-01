import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  Future<Database> getDatabase() async {
    final path = join(await getDatabasesPath(), 'teamgo.db');
    await copyDbIfNeeded(exists: await databaseExists(path), path: path);
    return openDatabase(path, readOnly: false);
  }

  Future copyDbIfNeeded({bool exists, String path}) async {
    if (!exists) {
      await copyDbToInternalStorage(path);
    } else {
      debugPrint('Opening existing database');
    }
  }

  Future copyDbToInternalStorage(String path) async {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    final data = await rootBundle.load(join('assets', 'teamgo_db'));
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
  }
}
