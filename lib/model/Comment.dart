import 'package:json_annotation/json_annotation.dart';

part 'Comment.g.dart';

@JsonSerializable(anyMap: true)
class Comment {
  String comment;
  bool init;
  String label;

  Comment({this.comment, this.init});


  factory Comment.fromJson(Map json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}