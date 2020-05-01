import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/login/repository/login_repository.dart';
import 'package:teamgoflutterapp/main.dart';
import 'package:teamgoflutterapp/navigation/custom_navigator.dart';
import 'package:teamgoflutterapp/navigation/navigation_event.dart';
import 'package:teamgoflutterapp/registration/bloc/registration_bloc.dart';
import 'package:teamgoflutterapp/registration/bloc/registration_event.dart';
import 'package:teamgoflutterapp/registration/bloc/registration_state.dart';
import 'package:test/test.dart';

void main() {
  group('RegistrationBloc', () {
    RegistrationBloc bloc;
    LoginRepository loginRepository;
    CustomNavigator customNavigator;

    setUp(() {
      loginRepository = MockLoginRepository();
      customNavigator = MockCustomNavigator();
      bloc = RegistrationBloc(loginRepository, customNavigator);
    });

    test('Saves photo and returns photo uploaded state', () async {
      //given
      final photo = File('/image.png');

      //when
      bloc.add(UploadPhotoEvent(photoFile: photo));

      //then
      await emitsExactly(bloc, [PhotoUploaded(photo)]);
      expect(bloc.photo, photo);
    });

    test('returns initial state and navigates when user registered succesfully',
        () async {
      //given
      when(loginRepository.registerUser(
              username: anyNamed('username'),
              password: anyNamed('password'),
              photo: anyNamed('photo')))
          .thenAnswer((_) => Future.value(true));

      //when
      bloc.add(RegisterUserEvent(username: 'username', password: 'password'));

      //then
      await emitsExactly(
          bloc, [RegistrationLoading(null), InitialRegistrationState()]);
      verify(customNavigator.handleNavigationEvent(
          NavigateToRouteAndCleatStack(AppRoutes.activitiesList)));
    });

    test('returns failure state when user not registered succesfully',
        () async {
      //given
      when(loginRepository.registerUser(
              username: anyNamed('username'),
              password: anyNamed('password'),
              photo: anyNamed('photo')))
          .thenAnswer((_) => Future.value(false));

      //when
      bloc.add(RegisterUserEvent(username: 'username', password: 'password'));

      //then
      await emitsExactly(bloc, [RegistrationLoading(null), RegistrationFailure()]);
    });
  });
}

class MockLoginRepository extends Mock implements LoginRepository {}

class MockCustomNavigator extends Mock implements CustomNavigator {}
