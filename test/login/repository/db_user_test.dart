import 'package:teamgoflutterapp/login/repository/db_user.dart';
import 'package:test/test.dart';

void main() {
  group('DbUser', () {
    final map = {'_id': 1, 'name': 'Harry Potter', 'avatar': 'avatar.png'};

    void verifyAllFieldsAreSet(DbUser user) {
      expect(user.id, 1);
      expect(user.username, 'Harry Potter');
      expect(user.photoFile.path, 'path/avatar.png');
    }

    test('should properly parse data fom map', () async {
      //when
      final user = DbUser.fromMap(map, 'path');

      //then
      verifyAllFieldsAreSet(user);
    });
  });
}
