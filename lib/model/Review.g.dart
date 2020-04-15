// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map json) {
  return Review(
    word: json['word'] as String,
    sentence: json['sentence'] as String,
    id: json['id'] as String,
    paragraph: json['paragraph'] as String,
    categories: (json['categories'] as List)
        ?.map((e) => e == null ? null : Category.fromJson(e as Map))
        ?.toList(),
    pageTitle: json['pageTitle'] as String,
    lastEdited: json['lastEdited'] == null
        ? null
        : DateTime.parse(json['lastEdited'] as String),
    reviewSpan: _$enumDecodeNullable(_$ReviewSpanEnumMap, json['reviewSpan']),
    comments: (json['comments'] as List)
        ?.map((e) => e == null ? null : Comment.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'pageTitle': instance.pageTitle,
      'word': instance.word,
      'sentence': instance.sentence,
      'paragraph': instance.paragraph,
      'lastEdited': instance.lastEdited?.toIso8601String(),
      'id': instance.id,
      'reviewSpan': _$ReviewSpanEnumMap[instance.reviewSpan],
      'categories': instance.categories,
      'comments': instance.comments,
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

const _$ReviewSpanEnumMap = {
  ReviewSpan.daily: 'daily',
  ReviewSpan.weekly: 'weekly',
  ReviewSpan.monthly: 'monthly',
  ReviewSpan.yearly: 'yearly',
};
