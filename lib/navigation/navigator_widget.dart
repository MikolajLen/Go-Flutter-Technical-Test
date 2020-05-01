import 'package:flutter/material.dart';
import '../db/file_manager.dart';
import '../login/repository/login_persister.dart';
import '../main.dart';
import 'custom_navigator.dart';
import 'navigation_event.dart';

class NavigatorWidget extends StatelessWidget {
  const NavigatorWidget(
      {Key key, this.loginPersister, this.customNavigator, this.fileManager})
      : super(key: key);

  final LoginPersister loginPersister;
  final CustomNavigator customNavigator;
  final FileManager fileManager;

  @override
  Widget build(BuildContext context) {
    fileManager.init().then((_) {
      debugPrint('Images initialized!');
      loginPersister.getUserId().then((id) => id == null
          ? customNavigator.handleNavigationEvent(
              NavigateToRouteAndCleatStack(AppRoutes.login))
          : customNavigator.handleNavigationEvent(
              NavigateToRouteAndCleatStack(AppRoutes.activitiesList)));
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
