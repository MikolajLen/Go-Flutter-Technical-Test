import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/login/repository/db_user.dart';
import 'package:teamgoflutterapp/login/repository/sqlite_login_helper.dart';
import 'package:teamgoflutterapp/login/persister/login_persister.dart';
import 'package:teamgoflutterapp/login/repository/sqlite_login_repository.dart';
import 'package:test/test.dart';

void main() {
  group('SqLiteLoginRepository', () {
    SqLiteLoginRepository sqLiteLoginRepository;
    SqLiteLoginHelper dbHelper;

    setUp(() {
      dbHelper = MockSqLiteLoginHelper();
      sqLiteLoginRepository =
          SqLiteLoginRepository(dbHelper, MockLoginPersister());
    });

    test('Fetches user in database', () async {
      //given
      final dbUser = MockDbUser();
      when(dbHelper.getUser('Username', 'Password'))
          .thenAnswer((_) => Future.value(dbUser));

      //when
      final result = await sqLiteLoginRepository.logUser(
          username: 'Username', password: 'Password');

      //then
      verify(dbHelper.getUser('Username', 'Password'));
      expect(result, true);
    });

    test('Register user in database', () async {
      //given
      final dbUser = MockDbUser();
      final photo = File('/img.png');
      when(dbHelper.registerUser('Username', 'Password', photo))
          .thenAnswer((_) => Future.value(dbUser));

      //when
      final result = await sqLiteLoginRepository.registerUser(
          username: 'Username', password: 'Password', photo: photo);

      //then
      verify(dbHelper.registerUser('Username', 'Password', photo));
      expect(result, true);
    });

    test('Clears user data after logout', () async {
      //given
      final dbUser = MockDbUser();
      when(dbHelper.getUser('Username', 'Password'))
          .thenAnswer((_) => Future.value(dbUser));
      await sqLiteLoginRepository.logUser(
          username: 'Username', password: 'Password');

      //when
      await sqLiteLoginRepository.logOutUser();

      //then
      //todo
    });
  });
}

class MockSqLiteLoginHelper extends Mock implements SqLiteLoginHelper {}

class MockDbUser extends Mock implements DbUser {}

class MockLoginPersister extends Mock implements LoginPersister {}
