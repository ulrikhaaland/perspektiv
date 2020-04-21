import 'dart:ui';

import 'package:perspektiv/model/Review.dart';

import 'Category.dart';
import 'Month.dart';
import 'package:json_annotation/json_annotation.dart';

import 'SubCategory.dart';

part 'Year.g.dart';

@JsonSerializable(anyMap: true)
class Year {
  String year;
  List<Month> months;
  Review review;
  @JsonKey(ignore: true)
  List<Category> aggregatedCategories;

  Year({this.months, this.year, this.review});

  factory Year.fromJson(Map json) => _$YearFromJson(json);

  Map<String, dynamic> toJson() => _$YearToJson(this);

  void aggregate() {
    if (months.isEmpty) return;

    aggregatedCategories = [];

    for (var month in months) {
      if (month.review != null) if (month.review.categories.isNotEmpty) {
        for (var category in month.review.categories) {
          Category cat = aggregatedCategories
              .singleWhere((c) => category.name == c.name, orElse: () => null);

          if (cat == null) {
            aggregatedCategories.add(Category(
                id: "aggregated",
                name: category.name,
                comments: []..addAll(category.comments),
                subCategories: []..addAll(category.subCategories)));
          } else {
            cat.subCategories.addAll(category.subCategories);
          }
        }
      }
    }
    if (aggregatedCategories.isNotEmpty)
      for (var category in aggregatedCategories) {
        if (category.subCategories.isNotEmpty) {
          SubCategory subSurvivor = category.subCategories[0];

          List<SubCategory> isEquals = category.subCategories
              .where((sub) => sub.name == subSurvivor.name)
              .toList();

          subSurvivor.percentage = subSurvivor.percentage / isEquals.length;

          for (var subCategory in isEquals) {
            if (subCategory != subSurvivor) {
              subSurvivor.percentage = subSurvivor.percentage +
                  (subCategory.percentage / isEquals.length);
              category.subCategories.remove(subCategory);
            }
          }
        }
      }
  }
}
