import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';

import 'Category.dart';
import 'Day.dart';

import 'package:json_annotation/json_annotation.dart';

part 'Week.g.dart';

@JsonSerializable(anyMap: true)
class Week {
  String week;
  List<Day> days;
  Review review;
  @JsonKey(ignore: true)
  List<Category> aggregatedCategories;

  Week({this.days, this.week, this.review});

  factory Week.fromJson(Map json) => _$WeekFromJson(json);

  Map<String, dynamic> toJson() => _$WeekToJson(this);

  void _aggregate() {
    aggregatedCategories = [];

    for (var day in days) {
      if (day.review.categories.isNotEmpty) {
        for (var category in day.review.categories) {
          Category cat = aggregatedCategories
              .firstWhere((c) => c.name == category.name, orElse: () => null);

          if (cat == null) {
            aggregatedCategories.add(category);
          } else {
            cat.subCategories.addAll(category.subCategories);
          }
        }
        if (aggregatedCategories.isNotEmpty)
          for (var category in aggregatedCategories) {
            if (category.subCategories.isNotEmpty) {
              SubCategory subSurvivor = category.subCategories[0];
              subSurvivor.percentage = subSurvivor.percentage / category.subCategories.length;
              for (var subCategory in category.subCategories) {
                // if(sub)
              }
            }
          }
      }
    }
  }
}
