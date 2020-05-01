import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teamgoflutterapp/db/database_provider.dart';
import 'package:teamgoflutterapp/db/file_manager.dart';
import 'package:teamgoflutterapp/login/repository/sqlite_login_helper.dart';
import 'package:test/test.dart';

void main() {
  group('SqLiteLoginHelper', () {
    DatabaseProvider databaseProvider;
    FileManager fileManager;
    SqLiteLoginHelper sqLiteLoginHelper;
    Database db;

    setUp(() {
      databaseProvider = MockDatabaseProvider();
      fileManager = MockFileManager();
      db = MockDb();
      when(fileManager.imagesPath).thenReturn('path');
      when(databaseProvider.getDatabase()).thenAnswer((_) => Future.value(db));

      sqLiteLoginHelper = SqLiteLoginHelper(databaseProvider, fileManager);
    });

    final result = [
      <String, dynamic>{
        '_id': 1,
        'name': 'Harry Potter',
        'avatar': 'avatar.png'
      }
    ];

    test('should return user from db', () async {
      //given
      when(db.query('Users',
              columns: anyNamed('columns'),
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
              limit: 1))
          .thenAnswer((_) => Future.value(result));

      //when
      final user = await sqLiteLoginHelper.getUser('Harry Potter', 'Test1234');

      //then
      verify(db.query('Users',
          columns: ['_id', 'name', 'avatar'],
          where: 'name = ? AND password = ?',
          whereArgs: [
            'Harry Potter',
            '07480fb9e85b9396af06f006cf1c95024af2531c65fb505cfbd0add1e2f31573'
          ],
          limit: 1));
      verify(db.close());
      expect(user.username, 'Harry Potter');
      expect(user.id, 1);
      expect(user.photoFile.path, 'path/avatar.png');
    });

    test('should register user in db', () async {
      //given
      when(db.query('Users',
              columns: anyNamed('columns'),
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
              limit: 1))
          .thenAnswer((_) => Future.value(result));

      //when
      final user = await sqLiteLoginHelper.registerUser(
          'Harry Potter', 'Test1234', null);

      //then
      verify(db.insert('Users', {
        'name': 'Harry Potter',
        'password':
            '07480fb9e85b9396af06f006cf1c95024af2531c65fb505cfbd0add1e2f31573',
        'avatar': null
      }));
      verify(db.close());
    });
  });
}

class MockDatabaseProvider extends Mock implements DatabaseProvider {}

class MockFileManager extends Mock implements FileManager {}

class MockDb extends Mock implements Database {}
