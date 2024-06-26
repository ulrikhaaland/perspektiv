import 'package:json_annotation/json_annotation.dart';
import 'package:perspektiv/model/Review.dart';

part 'Day.g.dart';

@JsonSerializable(anyMap: true)
class Day {
  DateTime dayDate;

  String day;

  Review review;

  String get dayName => _dayNames[dayDate.weekday - 1];

  Day({this.day, this.review, this.dayDate});

  factory Day.fromJson(Map json) => _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);
}

List<String> _dayNames = [
  'Mandag',
  'Tirsdag',
  'Onsdag',
  'Torsdag',
  'Fredag',
  'Lørdag',
  'Søndag'
];
