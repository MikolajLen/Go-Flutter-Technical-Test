import 'package:equatable/equatable.dart';
import '../../repository/activity.dart';

abstract class NewActivityState extends Equatable {
  const NewActivityState();

  @override
  List<Object> get props => [];
}

class InitialNewActivityState extends NewActivityState {}

class UpdatingState extends NewActivityState {}

class ActivityCreated extends NewActivityState {
  const ActivityCreated(this.activity);

  final Activity activity;
}
