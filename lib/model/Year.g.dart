// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Year.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Year _$YearFromJson(Map json) {
  return Year(
    months: (json['months'] as List)
        ?.map((e) => e == null ? null : Month.fromJson(e as Map))
        ?.toList(),
    year: json['year'] as int,
  );
}

Map<String, dynamic> _$YearToJson(Year instance) => <String, dynamic>{
      'year': instance.year,
      'months': instance.months,
    };
