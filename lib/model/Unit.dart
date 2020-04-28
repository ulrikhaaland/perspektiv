import 'package:json_annotation/json_annotation.dart';

import 'CustomUnit.dart';
import 'Weight.dart';

part 'Unit.g.dart';

enum UnitType {
  custom,
  binary,
  duration,
  weight,
}

@JsonSerializable(anyMap: true)
class Unit {
  UnitType type;
  Duration duration;
  Weight weight;
  CustomUnit customUnit;
  bool binary;

  Unit({
    this.type,
    this.duration,
    this.weight,
    this.customUnit,
    this.binary,
  });

  factory Unit.fromJson(Map json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);

  String getTitle() {
    switch (this.type) {
      case UnitType.custom:
        return customUnit == null ? "" : this.customUnit.unitName;
        break;
      case UnitType.binary:
        // TODO: Handle this case.
        break;
      case UnitType.duration:
        // TODO: Handle this case.
        break;
      case UnitType.weight:
        // TODO: Handle this case.
        break;
      default:
        return "Udefinert";
    }
  }
}
