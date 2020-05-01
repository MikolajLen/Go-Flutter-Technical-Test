import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../login/repository/login_repository.dart';
import '../../main.dart';
import '../../navigation/custom_navigator.dart';
import '../../navigation/navigation_event.dart';
import './bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc(this._loginRepository, this._customNavigator);

  final LoginRepository _loginRepository;
  final CustomNavigator _customNavigator;

  @visibleForTesting
  File photo;

  @override
  RegistrationState get initialState => InitialRegistrationState();

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is UploadPhotoEvent) {
      photo = event.photoFile;
      yield PhotoUploaded(photo);
    }
    if (event is RegisterUserEvent) {
      yield RegistrationLoading(photo);
      final isAccountCreated = await _loginRepository.registerUser(
          username: event.username, password: event.password, photo: photo);
      if (isAccountCreated) {
        yield InitialRegistrationState();
        await _customNavigator.handleNavigationEvent(
            NavigateToRouteAndCleatStack(AppRoutes.activitiesList));
      } else {
        yield RegistrationFailure();
      }
    }
  }
}
