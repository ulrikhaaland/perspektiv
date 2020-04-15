// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Decade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Decade _$DecadeFromJson(Map json) {
  return Decade(
    decade: json['decade'] as String,
    years: (json['years'] as List)
        ?.map((e) => e == null ? null : Year.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$DecadeToJson(Decade instance) => <String, dynamic>{
      'decade': instance.decade,
      'years': instance.years,
    };
