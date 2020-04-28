// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Unit _$UnitFromJson(Map json) {
  return Unit(
    type: _$enumDecodeNullable(_$UnitTypeEnumMap, json['type']),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
    weight:
        json['weight'] == null ? null : Weight.fromJson(json['weight'] as Map),
    customUnit: json['customUnit'] == null
        ? null
        : CustomUnit.fromJson(json['customUnit'] as Map),
    binary: json['binary'] as bool,
  );
}

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'type': _$UnitTypeEnumMap[instance.type],
      'duration': instance.duration?.inMicroseconds,
      'weight': instance.weight,
      'customUnit': instance.customUnit,
      'binary': instance.binary,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$UnitTypeEnumMap = {
  UnitType.custom: 'custom',
  UnitType.binary: 'binary',
  UnitType.duration: 'duration',
  UnitType.weight: 'weight',
};
