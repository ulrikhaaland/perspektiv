// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Weight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weight _$WeightFromJson(Map json) {
  return Weight(
    type: json['type'] as String,
    weight: (json['weight'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$WeightToJson(Weight instance) => <String, dynamic>{
      'type': instance.type,
      'weight': instance.weight,
    };
