import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:teamgoflutterapp/activities/repository/activity.dart';
import 'package:teamgoflutterapp/activities/newActivity/bloc/new_activity_state.dart';
import 'package:teamgoflutterapp/activities/newActivity/bloc/new_activity_event.dart';
import 'package:teamgoflutterapp/activities/newActivity/bloc/new_activity_bloc.dart';
import 'package:teamgoflutterapp/activities/repository/activities_repository.dart';
import 'package:teamgoflutterapp/login/repository/login_repository.dart';
import 'package:teamgoflutterapp/navigation/custom_navigator.dart';
import 'package:teamgoflutterapp/navigation/navigation_event.dart';
import 'package:test/test.dart';

void main() {
  group('NewActivityBloc', () {
    ActivitiesRepository activitiesRepository;
    NewActivityBloc newActivityBloc;
    LoginRepository loginRepository;
    CustomNavigator customNavigator;

    setUp(() {
      activitiesRepository = MockActivitiesRepository();
      customNavigator = MockCustomNavigator();
      loginRepository = MockLoginRepository();
      newActivityBloc = NewActivityBloc(
          activitiesRepository, loginRepository, customNavigator);
    });

    test('Should fill satate with selected activity', () async {
      //given
      final activity = Activity(id: 1);

      //when
      newActivityBloc.add(FillDataEvent(activity));

      //then
      await emitsExactly(newActivityBloc, [ActivityCreated(activity)]);
    });

    test('Should fetch activity', () async {
      //given
      when(loginRepository.getUserId()).thenAnswer((_) => Future.value(2));

      //when
      newActivityBloc.add(
          AddNewActivityEvent(1, 'photoUrl', 'what', 'where', 'when', 'desc'));

      //then
      await emitsExactly(newActivityBloc, [UpdatingState()]);
      verify(customNavigator.handleNavigationEvent(NavigatePop()));
      verify(activitiesRepository.addActivity(Activity(
          id: 1,
          userId: 2,
          photoUrl: 'photoUrl',
          what: 'what',
          where: 'where',
          when: 'when',
          detailedDescription: 'desc')));
    });
  });
}

class MockActivitiesRepository extends Mock implements ActivitiesRepository {}

class MockCustomNavigator extends Mock implements CustomNavigator {}

class MockLoginRepository extends Mock implements LoginRepository {}
