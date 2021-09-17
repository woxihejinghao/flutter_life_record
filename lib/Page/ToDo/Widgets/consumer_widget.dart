import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumerSingleWidget<T> extends StatelessWidget {
  final Widget child;
  const ConsumerSingleWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(builder: (context, data, c) => child);
  }
}
