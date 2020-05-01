import 'package:equatable/equatable.dart';

abstract class ActivityDetailsEvent extends Equatable {
  const ActivityDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchActivity extends ActivityDetailsEvent {

  const FetchActivity(this.id);

  final int id;
}

class EditActivityEvent extends ActivityDetailsEvent {}
