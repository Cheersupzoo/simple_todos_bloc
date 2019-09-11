// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoList _$TodoListFromJson(Map<String, dynamic> json) {
  return TodoList((json['todos'] as List)
      ?.map((e) =>
          e == null ? null : TodoModel.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$TodoListToJson(TodoList instance) =>
    <String, dynamic>{'todos': instance.todos};

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) {
  return TodoModel(
      complete: json['complete'] as bool,
      id: json['id'] as String,
      title: json['title'] as String,
      detail: json['detail'] as String);
}

Map<String, dynamic> _$TodoModelToJson(TodoModel instance) => <String, dynamic>{
      'complete': instance.complete,
      'id': instance.id,
      'title': instance.title,
      'detail': instance.detail
    };
