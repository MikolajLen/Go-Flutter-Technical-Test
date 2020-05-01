import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../login/repository/login_repository.dart';
import '../../../navigation/custom_navigator.dart';
import '../../../navigation/navigation_event.dart';
import '../../repository/activities_repository.dart';
import '../../repository/activity.dart';
import './bloc.dart';

class NewActivityBloc extends Bloc<NewActivityEvent, NewActivityState> {
  NewActivityBloc(
      this._activitiesRepository, this._loginRepository, this._customNavigator);

  final ActivitiesRepository _activitiesRepository;
  final LoginRepository _loginRepository;
  final CustomNavigator _customNavigator;

  @override
  NewActivityState get initialState => InitialNewActivityState();

  @override
  Stream<NewActivityState> mapEventToState(
    NewActivityEvent event,
  ) async* {
    if (event is AddNewActivityEvent) {
      yield UpdatingState();
      final userId = await _loginRepository.getUserId();
      final activity = Activity(
          id: event.id,
          userId: userId,
          what: event.what,
          where: event.where,
          when: event.when,
          photoUrl: event.photoUrl,
          detailedDescription: event.desc);
      await _activitiesRepository.addActivity(activity);
      await _customNavigator.handleNavigationEvent(NavigatePop());
    }
    if (event is FillDataEvent) {
      yield ActivityCreated(event.activity);
    }
  }
}
