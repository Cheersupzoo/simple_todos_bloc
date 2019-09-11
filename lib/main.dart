import 'package:flutter/material.dart';
import 'package:simple_todos_bloc/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todos_bloc/blocs/blocs.dart';

void main() {
  runApp(BlocProvider(
    builder: (context) {
      return TodosBloc()..dispatch(LoadTodos());
    },
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoApp(),
    );
  }
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new TodosScreen();
  }
}


