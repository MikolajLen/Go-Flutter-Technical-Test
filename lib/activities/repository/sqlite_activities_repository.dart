import 'activities_repository.dart';
import 'activity.dart';
import 'sqlite_activities_helper.dart';

class SqliteActivitiesRepository extends ActivitiesRepository {
  SqliteActivitiesRepository(this._sqliteActivitiesHelper);

  final SqliteActivitiesHelper _sqliteActivitiesHelper;

  @override
  Future<List<Activity>> fetchActivities() =>
      _sqliteActivitiesHelper.fetchActivities();

  @override
  Future<void> addActivity(Activity activity) async =>
      _sqliteActivitiesHelper.insertActivity(activity);

  @override
  Future<Activity> fetchActivity(int id) =>
      _sqliteActivitiesHelper.fetchActivity(id.toString());
}
