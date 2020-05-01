import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class UploadPhotoEvent extends RegistrationEvent {
  const UploadPhotoEvent({@required this.photoFile});

  final File photoFile;
}

class RegisterUserEvent extends RegistrationEvent {
  const RegisterUserEvent({@required this.username, @required this.password});

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}
