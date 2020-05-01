import '../../db/database_provider.dart';
import '../../db/file_manager.dart';
import 'activity.dart';

class SqliteActivitiesHelper {
  SqliteActivitiesHelper(this._databaseProvider, this._fileManager);

  final DatabaseProvider _databaseProvider;
  final FileManager _fileManager;

  Future<List<Activity>> fetchActivities() async {
    final db = await _databaseProvider.getDatabase();
    final activities = await db.rawQuery(fetchAllActivitiesQuery);
    await db.close();
    return activities
        .map((items) => Activity.fromMap(items, _fileManager.imagesPath))
        .toList();
  }

  Future<Activity> fetchActivity(String id) async {
    final db = await _databaseProvider.getDatabase();
    final activities = await db.rawQuery(fetchSelectedActivityQuery(id));
    await db.close();
    return activities
        .map((items) => Activity.fromMap(items, _fileManager.imagesPath))
        .first;
  }

  Future<void> insertActivity(Activity activity) async {
    final db = await _databaseProvider.getDatabase();
    if (activity.id != null) {
      await db.update(
          tableName,
          {
            userId: activity.userId,
            what: activity.what,
            where: activity.where,
            when: activity.when,
            photo: activity.photoUrl,
            desc: activity.detailedDescription
          },
          where: '_id = ?',
          whereArgs: [activity.id]);
    } else {
      await db.insert(tableName, {
        userId: activity.userId,
        what: activity.what,
        where: activity.where,
        when: activity.when,
        photo: activity.photoUrl,
        desc: activity.detailedDescription
      });
    }
    await db.close();
  }

  static const fetchAllActivitiesQuery = 'SELECT '
      'Activities._id as id, '
      'Users._id as userId, '
      'Users.name as username, '
      'Users.avatar as user_photo, '
      'Activities.what, '
      'Activities.place, '
      'Activities.when_to_start, '
      'Activities.created_at, '
      'Activities.photo_url, '
      'Activities.detailed_desc '
      'FROM Activities JOIN Users '
      'ON Activities.user_id = Users._id '
      'ORDER BY Activities.created_at DESC';

  static String fetchSelectedActivityQuery(String id) => 'SELECT '
      'Activities._id as id, '
      'Users._id as userId, '
      'Users.name as username, '
      'Users.avatar as user_photo, '
      'Activities.what, '
      'Activities.place, '
      'Activities.when_to_start, '
      'Activities.created_at, '
      'Activities.photo_url, '
      'Activities.detailed_desc '
      'FROM Activities JOIN Users '
      'ON Activities.user_id = Users._id '
      'WHERE Activities._id = $id '
      'ORDER BY Activities.created_at';

  static const tableName = 'Activities';
  static const userId = 'user_id';
  static const what = 'what';
  static const where = 'place';
  static const when = 'when_to_start';
  static const photo = 'photo_url';
  static const desc = 'detailed_desc';
}
