import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class InitialRegistrationState extends RegistrationState {}

class PhotoUploaded extends RegistrationState {
  const PhotoUploaded(this.image);

  final File image;

  @override
  List<Object> get props => [image];
}

class RegistrationLoading extends RegistrationState {

  const RegistrationLoading(this.image);

  final File image;

  @override
  List<Object> get props => [image];
}

class RegistrationFailure extends RegistrationState {}
