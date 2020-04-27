import 'package:json_annotation/json_annotation.dart';

part 'Unit.g.dart';

enum UnitType {
  duration,
  weight,
  binary,
  custom,
}

@JsonSerializable(anyMap: true)
class Unit {
  UnitType type;
  Duration duration;
  double weight;
  String custom;
  bool binary;
  String nameOfUnit;
  String value;

  Unit({this.type, this.duration, this.weight, this.custom, this.binary});

  factory Unit.fromJson(Map json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);

  String getTitle() {
    return this.nameOfUnit ?? "Ikke valgt";
  }
}
