import 'package:flutter/cupertino.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_home_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

ChangeNotifierProvider<T> buildProvider<T extends ChangeNotifier>(T value) {
  return ChangeNotifierProvider<T>.value(value: value);
}

List<SingleChildWidget> get providers => providers;

final List<ChangeNotifierProvider<dynamic>> _providers =
    <ChangeNotifierProvider<dynamic>>[
  buildProvider<ToDoHomeProvider>(ToDoHomeProvider())
];
