// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategory _$SubCategoryFromJson(Map json) {
  return SubCategory(
      name: json['name'] as String, color: Color(json['colorValue'] as int))
    ..colorValue = json['colorValue'] as int;
}

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'colorValue': instance.color.value,
    };
