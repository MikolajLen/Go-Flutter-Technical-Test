import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/activities/details/bloc/bloc.dart';
import 'package:teamgoflutterapp/activities/repository/activities_repository.dart';
import 'package:teamgoflutterapp/activities/repository/activity.dart';
import 'package:teamgoflutterapp/main.dart';
import 'package:teamgoflutterapp/navigation/custom_navigator.dart';
import 'package:teamgoflutterapp/navigation/navigation_event.dart';
import 'package:test/test.dart';

void main() {
  group('ActivityDetailsBloc', () {
    ActivitiesRepository activitiesRepository;
    ActivityDetailsBloc activitiesBloc;
    CustomNavigator customNavigator;

    setUp(() {
      activitiesRepository = MockActivitiesRepository();
      customNavigator = MockCustomNavigator();
      activitiesBloc =
          ActivityDetailsBloc(activitiesRepository, customNavigator);
    });

    test('Should fetch selected activity', () async {
      //given
      final activity = Activity(id: 1);
      when(activitiesRepository.fetchActivity(1))
          .thenAnswer((_) => Future.value(activity));

      //when
      activitiesBloc.add(FetchActivity(1));

      //then
      await emitsExactly(activitiesBloc, [ActivityLoaded(activity)]);
      verify(activitiesRepository.fetchActivity(1));
    });

    test('Should navigates to edit page and refresh screen ', () async {
      //given
      final activity = Activity(id: 1);
      activitiesBloc.activity = activity;
      when(customNavigator.handleNavigationEvent(
              NavigateToRoute(AppRoutes.newActivity, params: activity)))
          .thenAnswer((_) => Future.value(null));
      when(activitiesRepository.fetchActivity(1))
          .thenAnswer((_) => Future.value(activity));

      //when
      activitiesBloc.add(EditActivityEvent());

      //then
      await untilCalled(customNavigator.handleNavigationEvent(
          NavigateToRoute(AppRoutes.newActivity, params: activity)));
      verify(customNavigator.handleNavigationEvent(
          NavigateToRoute(AppRoutes.newActivity, params: activity)));
    });
  });
}

class MockActivitiesRepository extends Mock implements ActivitiesRepository {}

class MockCustomNavigator extends Mock implements CustomNavigator {}
