import 'package:equatable/equatable.dart';
import '../../repository/activity.dart';

abstract class ActivityDetailsState extends Equatable {
  const ActivityDetailsState();

  @override
  List<Object> get props => [];
}

class InitialActivityDetailsState extends ActivityDetailsState {}

class ActivityLoaded extends ActivityDetailsState {
  const ActivityLoaded(this.activity);

  final Activity activity;

  @override
  List<Object> get props => [activity];
}
