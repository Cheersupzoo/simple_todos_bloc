import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:simple_todos_bloc/providers/providers.dart';

part 'todo.g.dart';

@immutable
@JsonSerializable()
class TodoList extends Equatable {
  final List<TodoModel> todos;

  TodoList(this.todos);


  @override
  String toString() {
    return 'todoList { todos: $todos }';
  }

  factory TodoList.fromJson(Map<String, dynamic> json) =>
      _$TodoListFromJson(json);

  Map<String, dynamic> toJson() => _$TodoListToJson(this);

  @override
  List<Object> get props => [todos];
}

@immutable
@JsonSerializable()
class TodoModel extends Equatable {
  final bool complete;
  final String id;
  final String title;
  final String detail;

  TodoModel({this.complete = false, String id, this.title, this.detail = ''})
      : this.id = id ?? Uuid().generateV4(),
        super();

  TodoModel copyWith({bool complete, String id, String title, String detail}) {
    return TodoModel(
        complete: complete ?? this.complete,
        id: id ?? this.id,
        title: title ?? this.title,
        detail: detail ?? this.detail);
  }

  @override
  String toString() {
    return 'todo { title: $title, complete: $complete, detail: $detail, id: $id}';
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  @override
  List<Object> get props => [complete,id,title,detail];
}
