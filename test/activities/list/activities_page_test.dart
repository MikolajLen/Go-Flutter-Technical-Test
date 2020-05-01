import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/activities/list/activities_page.dart';
import 'package:teamgoflutterapp/activities/list/bloc/activities_bloc.dart';
import 'package:teamgoflutterapp/activities/list/bloc/activities_event.dart';
import 'package:teamgoflutterapp/activities/list/bloc/activities_state.dart';
import 'package:teamgoflutterapp/activities/repository/activity.dart';

import '../../test_utils.dart';

void main() {
  ActivitiesBloc activitiesBloc;

  setUp(() {
    activitiesBloc = MockActivitiesBloc();
  });

  void verifyActivitiesList() {
    expect(find.text('Who'), findsNWidgets(2));
    expect(find.text('What'), findsNWidgets(2));
    expect(find.text('When'), findsNWidgets(2));
    expect(find.text('Where'), findsNWidgets(2));
    expect(find.text('User1'), findsOneWidget);
    expect(find.text('yesterday'), findsOneWidget);
    expect(find.text('test activity'), findsOneWidget);
    expect(find.text('London'), findsOneWidget);
    expect(find.text('today'), findsOneWidget);
    expect(find.text('another activity'), findsOneWidget);
    expect(find.text('London'), findsOneWidget);
    expect(find.text('Boston'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsNWidgets(2));
  }

  List<Activity> mockActivitiesList(ActivitiesBloc activitiesBloc) {
    final activityOne = Activity(
        id: 1,
        userId: 1,
        username: 'User1',
        userPhoto: File('/img.png'),
        when: 'yesterday',
        what: 'test activity',
        where: 'London');
    final activityTwo = Activity(
        id: 2,
        userId: 2,
        username: 'User2',
        userPhoto: File('/test-img.png'),
        when: 'today',
        what: 'another activity',
        where: 'Boston');
    when(activitiesBloc.state)
        .thenReturn(ActivitiesLoaded([activityOne, activityTwo]));
    return [activityOne, activityTwo];
  }

  Widget initTestWidget(ActivitiesBloc activitiesBloc) {
    final widget = initTestApp(BlocProvider.value(
      value: activitiesBloc,
      child: ActivitiesPage(),
    ));
    return widget;
  }

  group('ActivitiesPage', () {
    testWidgets('Should show pogress when activities keeps loading',
        (WidgetTester tester) async {
      //given
      when(activitiesBloc.state).thenReturn(Uninitialized());
      final widget = initTestWidget(activitiesBloc);

      //when
      await tester.pumpWidget(widget);

      //then
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should show activities list when they are loaded',
        (WidgetTester tester) async {
      mockActivitiesList(activitiesBloc);
      final widget = initTestWidget(activitiesBloc);

      //when
      await tester.pumpWidget(widget);

      //then
      verifyActivitiesList();
    });

    testWidgets('Should log out when logout button pressed',
        (WidgetTester tester) async {
      //given
      mockActivitiesList(activitiesBloc);
      final widget = initTestWidget(activitiesBloc);
      await tester.pumpWidget(widget);

      //when
      await tester.tap(find.byIcon(Icons.exit_to_app));

      //then
      verify(activitiesBloc.add(LogOut()));
    });

    testWidgets('Should add new activity when FAB pressed pressed',
        (WidgetTester tester) async {
      //given
      mockActivitiesList(activitiesBloc);
      final widget = initTestWidget(activitiesBloc);
      await tester.pumpWidget(widget);

      //when
      await tester.tap(find.byType(FloatingActionButton));

      //then
      verify(activitiesBloc.add(AddActivity()));
    });

    testWidgets('Should navigate to activity details',
        (WidgetTester tester) async {
      //given
      final list = mockActivitiesList(activitiesBloc);
      final widget = initTestWidget(activitiesBloc);
      await tester.pumpWidget(widget);

      //when
      await tester.tap(find.byKey(Key('activity:1')));

      //then
      verify(activitiesBloc.add(ShowDetails(list[0])));
    });
  });
}

class MockActivitiesBloc extends MockBloc<ActivitiesEvent, ActivitiesState>
    implements ActivitiesBloc {}
