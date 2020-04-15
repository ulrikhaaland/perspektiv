// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map json) {
  return Category(
    id: json['id'] as String,
    name: json['name'] as String,
    subCategories: (json['subCategories'] as List)
        ?.map((e) => e == null ? null : SubCategory.fromJson(e as Map))
        ?.toList(),
    init: json['init'] as bool,
    comments: (json['comments'] as List)
        ?.map((e) => e == null ? null : Comment.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'init': instance.init,
      'comments': instance.comments,
      'subCategories': instance.subCategories,
    };
