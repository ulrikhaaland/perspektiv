import 'package:json_annotation/json_annotation.dart';

part 'Weight.g.dart';

@JsonSerializable(anyMap: true)
class Weight {
  String type;
  int weight;

  Weight({this.type, this.weight});

  factory Weight.fromJson(Map json) => _$WeightFromJson(json);

  Map<String, dynamic> toJson() => _$WeightToJson(this);
}
