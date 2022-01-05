import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

NavigatorState get navigatorState => LRInstances.navigatorKey.currentState!;

BuildContext get currentContext => navigatorState.context;

ThemeData get currentTheme => Theme.of(currentContext);

///路由观察者
RouteObserver<ModalRoute<void>> get routerObserver => LRInstances.routeObserver;

class LRInstances {
  const LRInstances._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();
}
