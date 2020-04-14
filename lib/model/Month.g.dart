// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Month.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Month _$MonthFromJson(Map json) {
  return Month(
    month: json['month'] as int,
    weeks: (json['weeks'] as List)
        ?.map((e) => e == null ? null : Week.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$MonthToJson(Month instance) => <String, dynamic>{
      'month': instance.month,
      'weeks': instance.weeks,
    };
