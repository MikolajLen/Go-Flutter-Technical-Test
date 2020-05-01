import 'package:shared_preferences/shared_preferences.dart';

class LoginPersister {
  final _userIdTag = 'userId';

  Future<void> persistUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdTag, id);
  }

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userIdTag) ? prefs.getInt(_userIdTag) : null;
  }

  Future<void> wipeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdTag);
  }
}
