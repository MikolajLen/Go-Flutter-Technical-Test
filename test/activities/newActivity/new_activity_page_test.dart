import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/activities/newActivity/bloc/new_activity_bloc.dart';
import 'package:teamgoflutterapp/activities/newActivity/bloc/new_activity_event.dart';
import 'package:teamgoflutterapp/activities/newActivity/bloc/new_activity_state.dart';
import 'package:teamgoflutterapp/activities/newActivity/new_activity_page.dart';
import 'package:teamgoflutterapp/activities/repository/activity.dart';

import '../../test_utils.dart';

void main() {
  NewActivityBloc newActivityBloc;

  setUp(() {
    newActivityBloc = MockNewActivityBloc();
  });

  Widget initTestWidget(NewActivityBloc activitiesBloc) {
    final widget = initTestApp(BlocProvider.value(
      value: activitiesBloc,
      child: NewActivityPage(),
    ));
    return widget;
  }

  void verifyFieldsAreSet() {
    expect(find.text('somewhere'), findsOneWidget);
    expect(find.text('playing cards'), findsOneWidget);
    expect(find.text('http://url'), findsOneWidget);
    expect(find.text('tomorrows'), findsOneWidget);
    expect(find.text('activity details'), findsOneWidget);
  }

  Future enterTestData(WidgetTester tester) async {
    await tester.enterText(find.byKey(Key('photoUrl')), 'photoUrl');
    await tester.enterText(find.byKey(Key('what')), 'what');
    await tester.enterText(find.byKey(Key('when')), 'when');
    await tester.enterText(find.byKey(Key('where')), 'where');
    await tester.enterText(find.byKey(Key('description')), 'description');
  }

  group('NewActivityPage', () {
    testWidgets('Should show progress when state is updating',
        (WidgetTester tester) async {
      //given
      when(newActivityBloc.state).thenReturn(UpdatingState());
      final widget = initTestWidget(newActivityBloc);

      //when
      await tester.pumpWidget(widget);

      //then
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should show error message when fields are empty',
        (WidgetTester tester) async {
      //given
      when(newActivityBloc.state).thenReturn(InitialNewActivityState());
      final widget = initTestWidget(newActivityBloc);
      await tester.pumpWidget(widget);

      //when
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();

      //then
      expect(find.text('Must not be empty'), findsNWidgets(4));
    });

    testWidgets('Should fill input fields when filldata state received',
        (WidgetTester tester) async {
      //given
      final activity = Activity(
          where: 'somewhere',
          what: 'playing cards',
          when: 'tomorrows',
          photoUrl: 'http://url',
          detailedDescription: 'activity details');
      when(newActivityBloc.state).thenReturn(ActivityCreated(activity));
      final widget = initTestWidget(newActivityBloc);

      //when
      await tester.pumpWidget(widget);

      //then
      verifyFieldsAreSet();
    });

    testWidgets('Should save data ', (WidgetTester tester) async {
      //given
      when(newActivityBloc.state).thenReturn(InitialNewActivityState());
      final widget = initTestWidget(newActivityBloc);
      await tester.pumpWidget(widget);
      await enterTestData(tester);

      //when
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();

      //then
      verify(newActivityBloc.add(AddNewActivityEvent(
          null, 'photoUrl', 'what', 'where', 'when', 'description')));
    });
  });
}

//
class MockNewActivityBloc extends MockBloc<NewActivityEvent, NewActivityState>
    implements NewActivityBloc {}
