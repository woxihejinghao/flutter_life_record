import 'package:flutter/cupertino.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_home_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

ChangeNotifierProvider<T> buildProvider<T extends ChangeNotifier>(T value,
    {Widget? child}) {
  return ChangeNotifierProvider<T>(
    create: (context) => value,
    child: child,
  );
}

ChangeNotifierProvider<T> valueProvider<T extends ChangeNotifier>(T value,
    {Widget? child}) {
  return ChangeNotifierProvider.value(
    value: value,
    child: child,
  );
}

List<SingleChildWidget> get providers => _providers;

final List<ChangeNotifierProvider<dynamic>> _providers =
    <ChangeNotifierProvider<dynamic>>[
  buildProvider<ToDoHomeProvider>(ToDoHomeProvider())
];
