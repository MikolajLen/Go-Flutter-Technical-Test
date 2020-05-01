import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teamgoflutterapp/login/bloc/bloc.dart';
import 'package:teamgoflutterapp/login/repository/login_repository.dart';
import 'package:teamgoflutterapp/main.dart';
import 'package:teamgoflutterapp/navigation/custom_navigator.dart';
import 'package:teamgoflutterapp/navigation/navigation_event.dart';
import 'package:test/test.dart';

void main() {
  group('LoginBloc', () {
    LoginBloc bloc;
    LoginRepository loginRepository;
    CustomNavigator customNavigator;

    setUp(() {
      loginRepository = MockLoginRepository();
      customNavigator = MockCustomNavigator();
      bloc = LoginBloc(loginRepository, customNavigator);
    });

    test('Navigate to activities page when user logged in succesfully',
        () async {
      //given
      when(loginRepository.logUser(
              username: anyNamed('username'), password: anyNamed('password')))
          .thenAnswer((_) => Future.value(true));

      //when
      bloc.add(LogUser('username', 'password'));

      //then
      await emitsExactly(bloc, [LoginLoading(), InitialLoginState()]);
      verify(customNavigator.handleNavigationEvent(
          NavigateToRouteAndCleatStack(AppRoutes.activitiesList)));
    });

    test('Navigate to registration when receive register action', () async {
      //when
      bloc.add(RegisterUser());

      //then
      await emitsExactly(bloc, []);
      verify(customNavigator
          .handleNavigationEvent(NavigateToRoute(AppRoutes.registration)));
    });

    test('returns failure state when loging failure', () async {
      //given
      when(loginRepository.logUser(
              username: anyNamed('username'), password: anyNamed('password')))
          .thenAnswer((_) => Future.value(false));

      //when
      bloc.add(LogUser('username', 'password'));

      //then
      await emitsExactly(bloc, [LoginLoading(), LoginFailure()]);
    });
  });
}

class MockLoginRepository extends Mock implements LoginRepository {}

class MockCustomNavigator extends Mock implements CustomNavigator {}
