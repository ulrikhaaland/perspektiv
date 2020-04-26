import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';

import 'Comment.dart';
import 'Unit.dart';

part 'SubCategory.g.dart';

@JsonSerializable(anyMap: true)
class SubCategory {
  String name;
  @JsonKey(ignore: true)
  Color color;
  int colorValue;
  double percentage;
  Unit unit;
  List<Comment> comments;

  SubCategory({
    this.name = "",
    this.color,
    this.percentage = 0,
    this.comments,
  });

  factory SubCategory.fromJson(Map json) => _$SubCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryToJson(this);
}
