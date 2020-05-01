import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginState extends Equatable{

  @override
  List<Object> get props => [];
}

class InitialLoginState extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {}
