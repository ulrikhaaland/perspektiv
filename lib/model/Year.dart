import 'dart:ui';

import 'package:perspektiv/model/Review.dart';

import 'Category.dart';
import 'Month.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Year.g.dart';

@JsonSerializable(anyMap: true)
class Year {
  int year;
  List<Month> months;
  Review review;

  Year({this.months, this.year, this.review});

  factory Year.fromJson(Map json) => _$YearFromJson(json);

  Map<String, dynamic> toJson() => _$YearToJson(this);
}
