import 'dart:ui';

import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Review.dart';

import 'Week.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Month.g.dart';

@JsonSerializable(anyMap: true)
class Month {
  Review review;
  String month;
  List<Week> weeks;

  String get monthName => _monthNames[int.parse(month) - 1];

  Month({
    this.month,
    this.weeks,
    this.review,
  });

  factory Month.fromJson(Map json) => _$MonthFromJson(json);

  Map<String, dynamic> toJson() => _$MonthToJson(this);
}

List<String> _monthNames = [
  'Januar',
  'Februar',
  'Mars',
  'April',
  'Mai',
  'Juni',
  'Juli',
  'August',
  'September',
  'Oktober',
  'November',
  'Desember',
];
