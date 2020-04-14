import 'Year.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Decade.g.dart';

@JsonSerializable(anyMap: true)
class Decade {
  int decade;
  List<Year> years;

  Decade({this.decade, this.years});

  factory Decade.fromJson(Map json) => _$DecadeFromJson(json);

  Map<String, dynamic> toJson() => _$DecadeToJson(this);
}
