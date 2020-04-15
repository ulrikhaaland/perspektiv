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
    year: json['year'] as String,
    review:
        json['review'] == null ? null : Review.fromJson(json['review'] as Map),
  );
}

Map<String, dynamic> _$YearToJson(Year instance) => <String, dynamic>{
      'year': instance.year,
      'months': instance.months,
      'review': instance.review,
    };
