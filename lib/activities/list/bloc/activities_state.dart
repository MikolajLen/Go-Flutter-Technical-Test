import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../repository/activity.dart';

@immutable
abstract class ActivitiesState extends Equatable {
  @override
  List<Object> get props => [];
}

class Uninitialized extends ActivitiesState {}

class ActivitiesLoadingError extends ActivitiesState {}

class ActivitiesLoaded extends ActivitiesState {
  ActivitiesLoaded(this.activities);

  final List<Activity> activities;

  @override
  List<Object> get props => [activities];
}
