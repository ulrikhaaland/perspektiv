import 'package:json_annotation/json_annotation.dart';

import 'Comment.dart';
import 'SubCategory.dart';

part 'Category.g.dart';

@JsonSerializable(anyMap: true)
class Category {
  String id;
  String name;
  bool init;
  List<Comment> comments;
  List<SubCategory> subCategories;

  Category(
      {this.id, this.name = "", this.subCategories, this.init, this.comments});

  factory Category.fromJson(Map json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}


