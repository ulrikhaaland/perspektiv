import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';

part 'SubCategory.g.dart';

@JsonSerializable(anyMap: true)
class SubCategory {
  String name;
  @JsonKey(ignore: true)
  Color color;
  int colorValue;
  double percentage;

  SubCategory({this.name, this.color, this.percentage});

  factory SubCategory.fromJson(Map json) => _$SubCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryToJson(this);
}
