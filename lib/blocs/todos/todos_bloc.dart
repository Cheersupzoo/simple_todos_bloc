import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:simple_todos_bloc/providers/providers.dart';
import 'package:simple_todos_bloc/models/models.dart';
import './todos.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  @override
  TodosState get initialState {
    return TodosLoading();
  }

  @override
  Stream<TodosState> mapEventToState(
    TodosEvent event,
  ) async* {
    if (event is LoadTodos) {
      yield* _mapLoadTodosToState();
    } else if (event is AddTodos) {
      yield* _mapAddTodosToState(event);
    } else if (event is UpdateTodos) {
      yield* _mapUpdateTodosToState(event);
    } else if (event is DeleteTodos) {
      yield* _mapDeleteTodosToState(event);
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    try {
      final todos = await FileStorage().loadTodos();
      yield TodosLoaded(todos);
    } catch (_) {
      yield TodosNotLoaded();
    }
  }

  Stream<TodosState> _mapAddTodosToState(AddTodos event) async* {
    if (currentState is TodosLoaded) {
      final List<TodoModel> updatedTodos =
          List.from((currentState as TodosLoaded).todos);
      updatedTodos.add(event.todo);
      _saveCourses(updatedTodos);
      yield TodosLoaded(updatedTodos);
    }
  }

  Stream<TodosState> _mapUpdateTodosToState(UpdateTodos event) async* {
    if (currentState is TodosLoaded) {

      final List<TodoModel> updatedCourses =
          (currentState as TodosLoaded).todos.map((course) {
        return course.id == event.updateTodo.id ? event.updateTodo : course;
      }).toList();
      yield TodosLoaded(updatedCourses);
      _saveCourses(updatedCourses);
    }
  }

  Stream<TodosState> _mapDeleteTodosToState(DeleteTodos event) async* {
    if (currentState is TodosLoaded) {
      final List<TodoModel> updatedTodos = (currentState as TodosLoaded)
          .todos
          .where((course) => course.id != event.deleteTodo.id)
          .toList();
      yield TodosLoaded(updatedTodos);
      _saveCourses(updatedTodos);
    }
  }

  Future _saveCourses(List<TodoModel> todos) {
    return FileStorage().saveTodos(todos);
  }
}
