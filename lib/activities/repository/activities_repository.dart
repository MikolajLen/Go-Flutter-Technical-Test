import 'activity.dart';

abstract class ActivitiesRepository {
  Future<List<Activity>> fetchActivities();

  Future<Activity> fetchActivity(int id);

  Future<void> addActivity(Activity activity);
}
