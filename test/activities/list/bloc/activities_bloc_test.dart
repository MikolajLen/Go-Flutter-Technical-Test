import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/activities/list/bloc/activities_bloc.dart';
import 'package:teamgoflutterapp/activities/list/bloc/activities_event.dart';
import 'package:teamgoflutterapp/activities/list/bloc/activities_state.dart';
import 'package:teamgoflutterapp/activities/repository/activities_repository.dart';
import 'package:teamgoflutterapp/activities/repository/activity.dart';
import 'package:teamgoflutterapp/login/repository/db_user.dart';
import 'package:teamgoflutterapp/login/repository/login_repository.dart';
import 'package:teamgoflutterapp/main.dart';
import 'package:teamgoflutterapp/navigation/custom_navigator.dart';
import 'package:teamgoflutterapp/navigation/navigation_event.dart';
import 'package:test/test.dart';

void main() {
  group('ActivitiesBloc', () {
    ActivitiesRepository activitiesRepository;
    LoginRepository loginRepository;
    CustomNavigator customNavigator;

    ActivitiesBloc activitiesBloc;

    setUp(() {
      activitiesRepository = MockActivitiesRepository();
      loginRepository = MockLoginRepository();
      customNavigator = MockCustomNavigator();

      activitiesBloc = ActivitiesBloc(
          activitiesRepository, loginRepository, customNavigator);
    });

    test('Should fetches activities', () async {
      //given
      final activities = [Activity(id: 1), Activity(id: 2), Activity(id: 3)];
      when(activitiesRepository.fetchActivities())
          .thenAnswer((_) => Future.value(activities));

      //when
      activitiesBloc.add(Fetch());

      //then
      await emitsExactly(activitiesBloc, [ActivitiesLoaded(activities)]);
      verify(activitiesRepository.fetchActivities());
    });

    test('Should logout user', () async {
      //given
      when(loginRepository.logOutUser()).thenAnswer((_) => Future.value(false));

      //when
      activitiesBloc.add(LogOut());

      //then
      await emitsExactly(activitiesBloc, []);
      verify(loginRepository.logOutUser());
      verify(customNavigator.handleNavigationEvent(
          NavigateToRouteAndCleatStack(AppRoutes.login)));
    });

    test('Navigates to activities details', () async {
      //when
      when(loginRepository.getUserId()).thenAnswer((_) => Future.value(2));
      activitiesBloc.add(ShowDetails(Activity(id: 1, userId: 2)));

      //then
      await untilCalled(customNavigator
          .handleNavigationEvent(NavigateToRoute(AppRoutes.activityDetails)));
      verify(customNavigator
          .handleNavigationEvent(NavigateToRoute(AppRoutes.activityDetails)));
    });

    test('Navigates to new activity page', () async {
      //when
      activitiesBloc.add(AddActivity());

      //then
      await untilCalled(customNavigator
          .handleNavigationEvent(NavigateToRoute(AppRoutes.newActivity)));
      verify(customNavigator
          .handleNavigationEvent(NavigateToRoute(AppRoutes.newActivity)));
    });
  });
}

class MockActivitiesRepository extends Mock implements ActivitiesRepository {}

class MockLoginRepository extends Mock implements LoginRepository {}

class MockCustomNavigator extends Mock implements CustomNavigator {}
