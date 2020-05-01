import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/activities/details/activity_details_page.dart';
import 'package:teamgoflutterapp/activities/details/bloc/bloc.dart';
import 'package:teamgoflutterapp/activities/repository/activity.dart';

import '../../image_test_utils.dart';
import '../../test_utils.dart';

void main() {
  final activity = Activity(
      id: 1,
      photoUrl: 'http://img.png',
      username: 'User1',
      userPhoto: File('/img.png'),
      when: 'yesterday',
      what: 'test activity',
      where: 'London',
      detailedDescription: 'Description');

  void verifyAllFieldsAreSet() {
    expect(find.text('Who'), findsOneWidget);
    expect(find.text('What'), findsOneWidget);
    expect(find.text('When'), findsOneWidget);
    expect(find.text('Where'), findsOneWidget);
    expect(find.text('User1'), findsOneWidget);
    expect(find.text('yesterday'), findsOneWidget);
    expect(find.text('test activity'), findsOneWidget);
    expect(find.text('London'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
  }

  ActivityDetailsBloc activityDetailsBloc;

  setUp(() {
    activityDetailsBloc = MockActivityDetailsBloc();
  });

  Widget initTestWidget(
      ActivityDetailsBloc activityDetailsBloc, bool editable) {
    final widget = initTestApp(BlocProvider.value(
      value: activityDetailsBloc,
      child: ActivityDetailsWidget(editable: editable),
    ));
    return widget;
  }

  group('ActivitiesPage', () {
    testWidgets('Should show progress when activity is loading',
        (WidgetTester tester) async {
      //given
      when(activityDetailsBloc.state).thenReturn(InitialActivityDetailsState());
      final widget = initTestWidget(activityDetailsBloc, false);

      //when
      await tester.pumpWidget(widget);

      //then
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should properly set all of the fields when activity is loaded',
        (WidgetTester tester) async {
      await provideMockedNetworkImages(() async {
        //given
        when(activityDetailsBloc.state).thenReturn(ActivityLoaded(activity));
        final widget = initTestWidget(activityDetailsBloc, false);

        //when
        await tester.pumpWidget(widget);

        //then
        verifyAllFieldsAreSet();
      });
    });
  });
}

class MockActivityDetailsBloc
    extends MockBloc<ActivityDetailsEvent, ActivityDetailsState>
    implements ActivityDetailsBloc {}
