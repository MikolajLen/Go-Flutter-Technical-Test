import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../login/repository/login_repository.dart';
import '../../../main.dart';
import '../../../navigation/custom_navigator.dart';
import '../../../navigation/navigation_event.dart';
import '../../repository/activities_repository.dart';

import './bloc.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  ActivitiesBloc(
      this._activitiesRepository, this._loginRepository, this._customNavigator);

  final ActivitiesRepository _activitiesRepository;
  final LoginRepository _loginRepository;
  final CustomNavigator _customNavigator;

  @override
  ActivitiesState get initialState => Uninitialized();

  @override
  Stream<ActivitiesState> mapEventToState(
    ActivitiesEvent event,
  ) async* {
    if (event is Fetch) {
      final activities = await _activitiesRepository.fetchActivities();
      yield ActivitiesLoaded(activities);
    }
    if (event is LogOut) {
      await _loginRepository.logOutUser();
      await _customNavigator
          .handleNavigationEvent(NavigateToRouteAndCleatStack(AppRoutes.login));
      yield state;
    }
    if (event is ShowDetails) {
      final userId = await _loginRepository.getUserId();
      await _customNavigator.handleNavigationEvent(NavigateToRoute(
          AppRoutes.activityDetails,
          params: [event.activity.id, event.activity.userId == userId]));
      add(Fetch());
    }
    if (event is AddActivity) {
      await _customNavigator
          .handleNavigationEvent(NavigateToRoute(AppRoutes.newActivity));
      add(Fetch());
    }
  }
}
