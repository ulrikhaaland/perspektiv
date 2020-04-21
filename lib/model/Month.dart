import 'dart:ui';

import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';

import 'Week.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Month.g.dart';

@JsonSerializable(anyMap: true)
class Month {
  Review review;
  String month;
  List<Week> weeks;
  @JsonKey(ignore: true)
  List<Category> aggregatedCategories;

  String get monthName => _monthNames[int.parse(month) - 1];

  Month({
    this.month,
    this.weeks,
    this.review,
  });

  factory Month.fromJson(Map json) => _$MonthFromJson(json);

  Map<String, dynamic> toJson() => _$MonthToJson(this);

  void aggregate() {
    if (weeks.isEmpty) return;

    aggregatedCategories = [];

    for (var week in weeks) {
      if (week.review != null) if (week.review.categories.isNotEmpty) {
        for (var category in week.review.categories) {
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

const List<String> _monthNames = [
  'Januar',
  'Februar',
  'Mars',
  'April',
  'Mai',
  'Juni',
  'Juli',
  'August',
  'September',
  'Oktober',
  'November',
  'Desember',
];
