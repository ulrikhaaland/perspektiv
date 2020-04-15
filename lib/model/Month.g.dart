// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Month.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Month _$MonthFromJson(Map json) {
  return Month(
    month: json['month'] as String,
    weeks: (json['weeks'] as List)
        ?.map((e) => e == null ? null : Week.fromJson(e as Map))
        ?.toList(),
    review:
        json['review'] == null ? null : Review.fromJson(json['review'] as Map),
  );
}

Map<String, dynamic> _$MonthToJson(Month instance) => <String, dynamic>{
      'review': instance.review,
      'month': instance.month,
      'weeks': instance.weeks,
    };
