import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../main.dart';
import '../../navigation/custom_navigator.dart';
import '../../navigation/navigation_event.dart';
import '../repository/login_repository.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._loginRepository, this._customNavigator);

  final LoginRepository _loginRepository;
  final CustomNavigator _customNavigator;

  @override
  LoginState get initialState => InitialLoginState();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LogUser) {
      yield LoginLoading();
      final isUserLoggedIn = await _loginRepository.logUser(
          username: event.username, password: event.password);
      if (isUserLoggedIn) {
        yield InitialLoginState();
        await _customNavigator.handleNavigationEvent(
            NavigateToRouteAndCleatStack(AppRoutes.activitiesList));
      } else {
        yield LoginFailure();
      }
    }
    if (event is RegisterUser) {
      yield InitialLoginState();
      await _customNavigator
          .handleNavigationEvent(NavigateToRoute(AppRoutes.registration));
    }
  }
}
