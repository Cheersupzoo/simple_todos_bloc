import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:simple_todos_bloc/models/models.dart';

@immutable
abstract class TodosEvent extends Equatable {
  TodosEvent([List props = const <dynamic>[]]) : super(props);
}

class LoadTodos extends TodosEvent {
  @override
  String toString() {
    return 'LoadTodos';
  }
}

class AddTodos extends TodosEvent {
  final TodoModel todo;

  AddTodos(this.todo) : super([todo]);

  @override
  String toString() => 'AddTodos { todo: $todo }';
}

class UpdateTodos extends TodosEvent {
  final TodoModel updateTodo;

  UpdateTodos(this.updateTodo) : super([updateTodo]);

  @override
  String toString() => 'UpdateTodos { updateTodo: $updateTodo }';
}

class DeleteTodos extends TodosEvent {
  final TodoModel deleteTodo;

  DeleteTodos(this.deleteTodo) : super([deleteTodo]);

  @override
  String toString() => 'DeleteTodos { deleteTodo: $deleteTodo }';
}
