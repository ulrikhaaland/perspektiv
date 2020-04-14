// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
    categories: (json['categories'] as List)
        ?.map((e) => e == null ? null : Category.fromJson(e as Map))
        ?.toList(),
    decade:
        json['decade'] == null ? null : Decade.fromJson(json['decade'] as Map),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'categories': instance.categories,
      'decade': instance.decade,
    };
