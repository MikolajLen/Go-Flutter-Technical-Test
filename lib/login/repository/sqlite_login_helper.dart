import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../../db/database_provider.dart';
import '../../db/file_manager.dart';
import 'db_user.dart';

class SqLiteLoginHelper {
  SqLiteLoginHelper(this._databaseProvider, this._fileManager);

  final DatabaseProvider _databaseProvider;
  final FileManager _fileManager;

  Future<DbUser> getUser(String username, String password) async {
    final db = await _databaseProvider.getDatabase();
    final passwordHash = _calculateHash(password);
    final users = await db.query(tableName,
        columns: columns,
        where: where,
        whereArgs: [username, passwordHash],
        limit: 1);
    await db.close();
    if (users.isEmpty) {
      return null;
    } else {
      return DbUser.fromMap(users[0], _fileManager.imagesPath);
    }
  }

  Future<DbUser> registerUser(
      String username, String password, File photo) async {
    String filename;
    if (photo != null) {
      filename = await _fileManager.copyFileToInternalStorage(photo);
    }
    final db = await _databaseProvider.getDatabase();
    await db.insert(tableName,
        {name: username, pass: _calculateHash(password), avatar: filename});
    await db.close();
    return getUser(username, password);
  }

  String _calculateHash(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static const tableName = 'Users';
  static const columns = ['_id', 'name', 'avatar'];
  static const where = 'name = ? AND password = ?';
  static const name = 'name';
  static const pass = 'password';
  static const avatar = 'avatar';
}
