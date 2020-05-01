import 'dart:async';

import 'package:flutter/material.dart';

import 'navigation_event.dart';

class CustomNavigator {
  CustomNavigator(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  Future<void> handleNavigationEvent(NavigationEvent event) async {
    if (event is NavigatePop) {
      navigatorKey.currentState.pop();
    }
    if (event is NavigateToRoute) {
      await navigatorKey.currentState
          .pushNamed(event.route, arguments: event.params);
    }
    if (event is NavigateToRouteAndCleatStack) {
      await navigatorKey.currentState
          .pushNamedAndRemoveUntil(event.route, (_) => false);
    }
  }
}
