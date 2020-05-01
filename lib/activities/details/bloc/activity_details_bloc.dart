import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../navigation/custom_navigator.dart';
import '../../../navigation/navigation_event.dart';
import '../../repository/activities_repository.dart';
import '../../repository/activity.dart';
import './bloc.dart';

class ActivityDetailsBloc
    extends Bloc<ActivityDetailsEvent, ActivityDetailsState> {
  ActivityDetailsBloc(this._activitiesRepository, this.customNavigator);

  final ActivitiesRepository _activitiesRepository;
  final CustomNavigator customNavigator;

  @override
  ActivityDetailsState get initialState => InitialActivityDetailsState();

  @visibleForTesting
  Activity activity;

  @override
  Stream<ActivityDetailsState> mapEventToState(
    ActivityDetailsEvent event,
  ) async* {
    if (event is FetchActivity) {
      activity = await _activitiesRepository.fetchActivity(event.id);
      yield ActivityLoaded(activity);
    }

    if (event is EditActivityEvent) {
      await customNavigator.handleNavigationEvent(
          NavigateToRoute(AppRoutes.newActivity, params: activity));
      yield ActivityLoaded(activity);
      add(FetchActivity(activity.id));
    }
  }
}
