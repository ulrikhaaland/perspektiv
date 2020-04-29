import 'dart:ui';

import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';

import 'Aggregated.dart';
import 'Comment.dart';
import 'Unit.dart';
import 'Week.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Month.g.dart';

@JsonSerializable(anyMap: true)
class Month {
  Review review;
  String month;
  List<Week> weeks;
  @JsonKey(ignore: true)
  Aggregated get aggregated => _aggregate();

  String get monthName => _monthNames[int.parse(month) - 1];

  Month({
    this.month,
    this.weeks,
    this.review,
  });

  factory Month.fromJson(Map json) => _$MonthFromJson(json);

  Map<String, dynamic> toJson() => _$MonthToJson(this);

  Aggregated _aggregate() {
    if (weeks.isEmpty) return Aggregated([], 100);

    List<Category> aggregatedList = [];
    double largestSubCatPercentage = 100;

    for (var week in weeks) {
      if (week.review != null) if (week.review.categories.isNotEmpty) {
        for (var category in week.review.categories) {
          Category cat = aggregatedList
              .singleWhere((c) => category.name == c.name, orElse: () => null);

          if (cat == null) {
            Category newCat = Category(
                id: "aggregated",
                name: category.name,
                comments: [],
                subCategories: []);

            if (category.comments != null)
              for (Comment comment in category.comments) {
                newCat.comments
                    .add(Comment(comment: comment.comment, init: comment.init));
              }
            if (category.subCategories != null)
              for (SubCategory sub in category.subCategories) {
                SubCategory newSub = SubCategory(
                  name: sub.name,
                  percentage: sub.percentage,
                  color: sub.color,
                  description: sub.description,
                  units: [],
                  comments: [],
                );
                if (sub.comments != null)
                  for (Comment comment in sub.comments) {
                    newSub.comments.add(Comment(
                      comment: comment.comment,
                      init: comment.init,
                    ));
                  }
                if (sub.units != null)
                  for (Unit unit in sub.units) {
                    newSub.units.add(Unit(
                      type: unit.type,
                      duration: unit.duration,
                      weight: unit.weight,
                      customUnit: unit.customUnit,
                      binary: unit.binary,
                    ));
                  }
                newCat.subCategories.add(newSub);
              }

            aggregatedList.add(newCat);
          } else {
            for (SubCategory sub in category.subCategories) {
              SubCategory checkIfExists = cat.subCategories
                  .firstWhere((s) => s.name == sub.name, orElse: () => null);
              if (checkIfExists == null) {
                SubCategory newSub = SubCategory(
                  name: sub.name,
                  percentage: sub.percentage,
                  color: sub.color,
                  description: sub.description,
                  units: []..addAll(sub.units ?? []),
                  comments: []..addAll(sub.comments ?? []),
                );
                if (sub.units != null)
                  for (Unit unit in sub.units) {
                    newSub.units.add(Unit(
                      type: unit.type,
                      duration: unit.duration,
                      weight: unit.weight,
                      customUnit: unit.customUnit,
                      binary: unit.binary,
                    ));
                  }
                if (sub.comments != null)
                  for (Comment comment in sub.comments) {
                    newSub.comments.add(Comment(
                      comment: comment.comment,
                      init: comment.init,
                    ));
                  }
                cat.subCategories.add(newSub);
              } else {
                checkIfExists.percentage =
                    checkIfExists.percentage + sub.percentage;

                if (checkIfExists.percentage > largestSubCatPercentage)
                  largestSubCatPercentage = checkIfExists.percentage;
              }
            }
          }
        }
      }
    }

    return Aggregated(aggregatedList, largestSubCatPercentage);
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
