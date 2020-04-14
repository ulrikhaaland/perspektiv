// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Day _$DayFromJson(Map json) {
  return Day(
    day: json['day'] == null ? null : DateTime.parse(json['day'] as String),
  );
}

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'day': instance.day?.toIso8601String(),
    };
