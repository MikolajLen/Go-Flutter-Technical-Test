import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/activities/repository/activity.dart';
import 'package:teamgoflutterapp/activities/repository/sqlite_activities_helper.dart';
import 'package:teamgoflutterapp/activities/repository/sqlite_activities_repository.dart';
import 'package:test/test.dart';

void main() {
  group('SqliteActivitiesRepository', () {
    SqliteActivitiesHelper helper;
    SqliteActivitiesRepository repository;

    setUp(() {
      helper = MockSqliteActivitiesHelper();
      repository = SqliteActivitiesRepository(helper);
    });

    test('should fetch all activities', () async {
      //when
      repository.fetchActivities();

      //then
      verify(helper.fetchActivities());
    });

    test('should fetch selected activity', () async {
      //when
      repository.fetchActivity(12);

      //then
      verify(helper.fetchActivity(12.toString()));
    });

    test('should insert new activity', () async {
      //given
      final activity = Activity(id: 3);

      //when
      repository.addActivity(activity);

      //then
      verify(helper.insertActivity(activity));
    });
  });
}

class MockSqliteActivitiesHelper extends Mock
    implements SqliteActivitiesHelper {}
