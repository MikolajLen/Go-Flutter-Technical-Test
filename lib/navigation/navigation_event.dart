import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigatePop extends NavigationEvent {}

class NavigateToRoute extends NavigationEvent {
  const NavigateToRoute(this.route, {this.params});

  final dynamic params;
  final String route;
}

class NavigateToRouteAndCleatStack extends NavigationEvent {
  const NavigateToRouteAndCleatStack(this.route);

  final String route;
}
