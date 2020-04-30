import 'dart:ui';

import 'package:perspektiv/model/Review.dart';

import 'Aggregated.dart';
import 'Category.dart';
import 'Comment.dart';
import 'Month.dart';
import 'package:json_annotation/json_annotation.dart';

import 'SubCategory.dart';
import 'Unit.dart';

part 'Year.g.dart';

@JsonSerializable(anyMap: true)
class Year {
  String year;
  List<Month> months;
  Review review;

  @JsonKey(ignore: true)
  Aggregated get aggregated => _aggregate();

  Year({this.months, this.year, this.review});

  factory Year.fromJson(Map json) => _$YearFromJson(json);

  Map<String, dynamic> toJson() => _$YearToJson(this);

  Aggregated _aggregate() {
    if (months.isEmpty) return Aggregated([], 100);

    List<Category> aggregatedList = [];
    double largestSubCatPercentage = 100;

    for (var month in months) {
      if (month.review != null) if (month.review.categories.isNotEmpty) {
        for (var category in month.review.categories) {
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
