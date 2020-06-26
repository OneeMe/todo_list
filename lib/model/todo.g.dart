// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return $checkedNew('Todo', json, () {
    final val = Todo(
        id: $checkedConvert(json, 'id', (v) => v as String),
        title: $checkedConvert(json, 'title', (v) => v as String),
        description: $checkedConvert(json, 'description', (v) => v as String),
        date: $checkedConvert(json, 'date',
            (v) => v == null ? null : Todo._dateFromJSON(v as String)),
        priority: $checkedConvert(json, 'priority',
            (v) => v == null ? null : Todo._priortyFromJSON(v as int)),
        isFinished: $checkedConvert(
            json, 'isFinished', (v) => Todo._boolFromJSON(v as int)),
        isStar: $checkedConvert(
            json, 'isStar', (v) => Todo._boolFromJSON(v as int)));
    return val;
  });
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date == null ? null : Todo._dateToJSON(instance.date),
      'priority': instance.priority == null
          ? null
          : Todo._priorityToJSON(instance.priority),
      'isFinished': Todo._boolToJSON(instance.isFinished),
      'isStar': Todo._boolToJSON(instance.isStar)
    };
