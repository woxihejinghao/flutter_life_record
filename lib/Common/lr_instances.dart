import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

NavigatorState get navigatorState => LRInstances.navigatorKey.currentState!;

BuildContext get currentContext => navigatorState.context;

ThemeData get currentTheme => Theme.of(currentContext);

class LRInstances {
  const LRInstances._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
