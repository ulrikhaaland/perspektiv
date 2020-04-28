// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategory _$SubCategoryFromJson(Map json) {
  return SubCategory(
    name: json['name'] as String,
    percentage: (json['percentage'] as num)?.toDouble(),
    color: Color(json['colorValue'] as int),
    comments: (json['comments'] as List)
        ?.map((e) => e == null ? null : Comment.fromJson(e as Map))
        ?.toList(),
  )
    ..colorValue = json['colorValue'] as int
    ..units = (json['units'] as List)
        ?.map((e) => e == null ? null : Unit.fromJson(e as Map))
        ?.toList();
}

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'colorValue': instance.color.value,
      'percentage': instance.percentage,
      'units': instance.units,
      'comments': instance.comments,
    };
