import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/activities/repository/sqlite_activities_helper.dart';
import 'package:teamgoflutterapp/db/database_provider.dart';
import 'package:teamgoflutterapp/db/file_manager.dart';
import 'package:test/test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teamgoflutterapp/activities/repository/activity.dart';

void main() {
  group('SqliteActivitiesRepository', () {
    DatabaseProvider databaseProvider;
    FileManager fileManager;
    SqliteActivitiesHelper sqliteActivitiesHelper;
    Database db;

    setUp(() {
      databaseProvider = MockDatabaseProvider();
      fileManager = MockFileManager();
      db = MockDb();
      when(fileManager.imagesPath).thenReturn('path');
      when(databaseProvider.getDatabase()).thenAnswer((_) => Future.value(db));

      sqliteActivitiesHelper =
          SqliteActivitiesHelper(databaseProvider, fileManager);
    });

    final response = [
      <String, dynamic>{
        'id': 1,
        'userId': 3,
        'username': 'Harry Potter',
        'user_photo': 'harry.png',
        'what': 'Attend the course of the magic tricks',
        'place': 'Somewhere in the Hogwart',
        'when_to_start': 'Every Wednesday',
        'created_at': '2020-05-01 21:04:49',
        'photo_url': 'https://image.jpg',
        'detailed_desc': 'Lorem ipsum'
      }
    ];

    void verifyAllFieldsAreSet(Activity activity) {
      expect(activity.id, 1);
      expect(activity.userId, 3);
      expect(activity.username, 'Harry Potter');
      expect(activity.userPhoto.path, 'path/harry.png');
      expect(activity.what, 'Attend the course of the magic tricks');
      expect(activity.where, 'Somewhere in the Hogwart');
      expect(activity.when, 'Every Wednesday');
      expect(activity.createdAt, '2020-05-01 21:04:49');
      expect(activity.photoUrl, 'https://image.jpg');
      expect(activity.detailedDescription, 'Lorem ipsum');
    }

    test('should fetch all activities and close db', () async {
      //given
      when(db.rawQuery(SqliteActivitiesHelper.FETACH_ALL_ACTIVITIES_QUERY))
          .thenAnswer((_) => Future.value(response));

      //when
      final result = await sqliteActivitiesHelper.fetchActivities();

      //then
      verify(db.rawQuery(SqliteActivitiesHelper.FETACH_ALL_ACTIVITIES_QUERY));
      verify(db.close());
      verifyAllFieldsAreSet(result[0]);
    });

    test('should selected activity and close db', () async {
      //given
      when(db.rawQuery(
              SqliteActivitiesHelper.fetchSelectedActivityQuery(1.toString())))
          .thenAnswer((_) => Future.value(response));
      //when
      final result = await sqliteActivitiesHelper.fetchActivity(1.toString());

      //then
      verify(db.rawQuery(
          SqliteActivitiesHelper.fetchSelectedActivityQuery(1.toString())));
      verify(db.close());
      verifyAllFieldsAreSet(result);
    });

    test('should update activity when id specified', () async {
      //given
      final activity = Activity(
          id: 1,
          userId: 2,
          photoUrl: 'url',
          when: 'when',
          where: 'where',
          what: 'what',
          detailedDescription: 'detailedDesc');

      //when
      await sqliteActivitiesHelper.insertActivity(activity);

      //then
      verify(db.update('Activities', {
        'user_id': activity.userId,
        'what': activity.what,
        'place': activity.where,
        'when_to_start': activity.when,
        'photo_url': activity.photoUrl,
        'detailed_desc': activity.detailedDescription
      },
      where: '_id = ?',
      whereArgs: [1]));
    });

    test('should inset new activity when id not specified', () async {
      //given
      final activity = Activity(
          userId: 2,
          photoUrl: 'url',
          when: 'when',
          where: 'where',
          what: 'what',
          detailedDescription: 'detailedDesc');

      //when
      await sqliteActivitiesHelper.insertActivity(activity);

      //then
      verify(db.insert('Activities', {
        'user_id': activity.userId,
        'what': activity.what,
        'place': activity.where,
        'when_to_start': activity.when,
        'photo_url': activity.photoUrl,
        'detailed_desc': activity.detailedDescription
      }));
    });
  });
}

class MockDatabaseProvider extends Mock implements DatabaseProvider {}

class MockFileManager extends Mock implements FileManager {}

class MockDb extends Mock implements Database {}
