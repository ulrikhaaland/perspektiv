// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map json) {
  return Comment(
    comment: json['comment'] as String,
    init: json['init'] as bool,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'comment': instance.comment,
      'init': instance.init,
    };
