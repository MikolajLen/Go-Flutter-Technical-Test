import 'package:shared_preferences/shared_preferences.dart';

import 'login_persister.dart';

class SqliteLoginPersister extends LoginPersister {
  SqliteLoginPersister(this._sharedPreferencesProvider);

  final _userIdTag = 'userId';

  final Future<SharedPreferences> _sharedPreferencesProvider;

  @override
  Future<int> getUserId() async {
    final prefs = await _sharedPreferencesProvider;
    return prefs.containsKey(_userIdTag) ? prefs.getInt(_userIdTag) : null;
  }

  @override
  Future<void> persistUserId(int id) async {
    final prefs = await _sharedPreferencesProvider;
    await prefs.setInt(_userIdTag, id);
  }

  @override
  Future<void> wipeUserData() async {
    final prefs = await _sharedPreferencesProvider;
    await prefs.remove(_userIdTag);
  }
}
