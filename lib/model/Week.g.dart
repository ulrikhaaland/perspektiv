// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Week.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Week _$WeekFromJson(Map json) {
  return Week(
    days: (json['days'] as List)
        ?.map((e) => e == null ? null : Day.fromJson(e as Map))
        ?.toList(),
    week: json['week'] as String,
    review:
        json['review'] == null ? null : Review.fromJson(json['review'] as Map),
  );
}

Map<String, dynamic> _$WeekToJson(Week instance) => <String, dynamic>{
      'week': instance.week,
      'days': instance.days,
      'review': instance.review,
    };
