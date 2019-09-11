import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todos_bloc/blocs/blocs.dart';
import 'package:simple_todos_bloc/models/models.dart';
import 'package:simple_todos_bloc/screens/detail-add.dart';
import 'package:simple_todos_bloc/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todosBloc = BlocProvider.of<TodosBloc>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Todo App',
        )),
        body: BlocBuilder(
            bloc: todosBloc,
            builder: (BuildContext context, TodosState state) {
              if (state is TodosLoading) {
                return LoadingIndicator(key: Key('__TodosLoading'));
              } else if (state is TodosLoaded) {
                final todos = state.todos;
                return ListView.builder(
                  key: Key('__ListTodos__'),
                  itemCount: todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = todos[index];
                    return Card(
                      elevation: 8.0,
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => DetailAddScreen(
                                      id: todo.id,
                                      isEditing: false,
                                    ))),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => todosBloc.dispatch(UpdateTodos(
                                    todo.copyWith(complete: !todo.complete))),
                                child: todo.complete == false
                                    ? Icon(Icons.check_box_outline_blank)
                                    : Icon(Icons.check_box),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text('${todo.title}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => DetailAddScreen(
                                      isEditing: true,
                                    )));
          },
        ));
  }
}
