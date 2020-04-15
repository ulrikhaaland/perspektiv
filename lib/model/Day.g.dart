// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Day _$DayFromJson(Map json) {
  return Day(
    day: json['day'] as String,
    review:
        json['review'] == null ? null : Review.fromJson(json['review'] as Map),
    dayDate: json['dayDate'] == null
        ? null
        : DateTime.parse(json['dayDate'] as String),
  );
}

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'dayDate': instance.dayDate?.toIso8601String(),
      'day': instance.day,
      'review': instance.review,
    };
