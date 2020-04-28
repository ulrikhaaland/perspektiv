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

  String get formattedDuration {
    String countHours =
        duration.inHours > 0 ? (duration.inHours.toString() + "t") : "";
    String countMinutes = (duration.inMinutes % 60) > 0
        ? ((duration.inMinutes % 60).toString() + "m")
        : "";
    String countSeconds = (duration.inSeconds % 60) > 0
        ? ((duration.inSeconds % 60).toString() + "s")
        : "";
    return countHours + countMinutes + countSeconds;
  }

  String getTitle() {
    switch (this.type) {
      case UnitType.custom:
        return customUnit == null
            ? ""
            : (this.customUnit.unitValue + this.customUnit.unitName);
        break;
      case UnitType.binary:
        return "Gjøremål";
        break;
      case UnitType.duration:
        return formattedDuration;
        break;
      case UnitType.weight:
        return weight.weight.toString() + " " + weight.type;
        break;
      default:
        return "Udefinert";
    }
  }
}
