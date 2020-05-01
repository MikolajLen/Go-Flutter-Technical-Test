import 'package:teamgoflutterapp/activities/repository/activity.dart';
import 'package:test/test.dart';

void main() {
  group('Activity', ()
  {
    final map = {
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
    };

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

    test('should properly parse data fom map', () async {
      //when
      final activity = Activity.fromMap(map, 'path');

      //then
      verifyAllFieldsAreSet(activity);
    });
  });
}


