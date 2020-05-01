import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:teamgoflutterapp/activities/repository/activity.dart';
import 'package:teamgoflutterapp/activities/widget/activity_widget.dart';

import '../../test_utils.dart';

void main() {
  final activity = Activity(
      id: 1,
      username: 'User1',
      userPhoto: File('/img.png'),
      when: 'yesterday',
      what: 'test activity',
      where: 'London');

  void verifyAllFieldsAreSet() {
    expect(find.text('Who'), findsOneWidget);
    expect(find.text('What'), findsOneWidget);
    expect(find.text('When'), findsOneWidget);
    expect(find.text('Where'), findsOneWidget);
    expect(find.text('User1'), findsOneWidget);
    expect(find.text('yesterday'), findsOneWidget);
    expect(find.text('test activity'), findsOneWidget);
    expect(find.text('London'), findsOneWidget);
  }

  testWidgets('Should properly set all of the fields',
      (WidgetTester tester) async {
    //given
    final widget = initTestApp(ActivityWidget(
      widgetActivity: activity,
    ));

    //when
    await tester.pumpWidget(widget);

    //then
    verifyAllFieldsAreSet();
  });
}
