import 'package:json_annotation/json_annotation.dart';

part 'CustomUnit.g.dart';


@JsonSerializable(anyMap: true)
class CustomUnit {
  String unitName;
  String unitValue;

  CustomUnit({this.unitName, this.unitValue});

  factory CustomUnit.fromJson(Map json) => _$CustomUnitFromJson(json);

  Map<String, dynamic> toJson() => _$CustomUnitToJson(this);
}