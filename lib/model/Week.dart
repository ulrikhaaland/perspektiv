import 'package:perspektiv/model/Review.dart';

import 'Day.dart';

import 'package:json_annotation/json_annotation.dart';

part 'Week.g.dart';

@JsonSerializable(anyMap: true)
class Week {
  int week;
  List<Day> days;
  Review review;

  Week({this.days, this.week, this.review});

  factory Week.fromJson(Map json) => _$WeekFromJson(json);

  Map<String, dynamic> toJson() => _$WeekToJson(this);
}
