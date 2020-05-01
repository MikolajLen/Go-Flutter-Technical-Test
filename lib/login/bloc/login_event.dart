import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class LogUser extends LoginEvent {
  LogUser(this.username, this.password);

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

class RegisterUser extends LoginEvent {}
