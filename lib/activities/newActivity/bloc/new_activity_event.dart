import 'package:equatable/equatable.dart';
import '../../repository/activity.dart';

abstract class NewActivityEvent extends Equatable {
  const NewActivityEvent();

  @override
  List<Object> get props => [];
}

class AddNewActivityEvent extends NewActivityEvent {
  const AddNewActivityEvent(
      this.id, this.photoUrl, this.what, this.where, this.when, this.desc);

  final int id;
  final String photoUrl;
  final String what;
  final String where;
  final String when;
  final String desc;
}

class FillDataEvent extends NewActivityEvent {
  const FillDataEvent(this.activity);

  final Activity activity;
}
