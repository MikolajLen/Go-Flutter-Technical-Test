import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repository/activity.dart';

@immutable
abstract class ActivitiesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Fetch extends ActivitiesEvent {}

class AddActivity extends ActivitiesEvent {}

class ShowDetails extends ActivitiesEvent {
  ShowDetails(this.activity);

  final Activity activity;
}

class LogOut extends ActivitiesEvent {}
