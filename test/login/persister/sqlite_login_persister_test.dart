import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamgoflutterapp/login/persister/sqlite_login_persister.dart';
import 'package:test/test.dart';

void main() {
  group('SqliteLoginPersister', () {
    SqliteLoginPersister persister;
    SharedPreferences preferences;

    setUp(() {
      preferences = MockedPreferences();
      persister = SqliteLoginPersister(Future.value(preferences));
    });

    test('Should return user id from preferences', () async {
      //given
      when(preferences.containsKey('userId')).thenReturn(true);
      when(preferences.getInt('userId')).thenReturn(123);

      //when
      final result = await persister.getUserId();

      //then
      expect(result, 123);
    });

    test('Should return null when user id not stored', () async {
      //given
      when(preferences.containsKey('userId')).thenReturn(false);

      //when
      final result = await persister.getUserId();

      //then
      expect(result, isNull);
    });

    test('Should persist user id in preferences', () async {
      //when
      await persister.persistUserId(123);

      //then
      verify(preferences.setInt('userId', 123));
    });

    test('Should wipe user data drom preferences', () async {
      //when
      await persister.wipeUserData();

      //then
      verify(preferences.remove('userId'));
    });
  });
}

class MockedPreferences extends Mock implements SharedPreferences {}
