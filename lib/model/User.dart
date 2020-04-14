import 'package:perspektiv/model/Category.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perspektiv/model/Decade.dart';

part 'User.g.dart';

@JsonSerializable(anyMap: true)
class User {
  List<Category> categories;
  @JsonKey(ignore: true)
  DateTime initDate;
  Decade decade;

  User({this.categories, this.initDate, this.decade});

  factory User.fromJson(Map json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
