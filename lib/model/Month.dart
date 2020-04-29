import 'dart:ui';

import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';

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

            aggregatedCategories.add(newCat);
          } else {
            for (SubCategory sub in category.subCategories) {
              SubCategory checkIfExists = cat.subCategories
                  .firstWhere((s) => s.name == sub.name, orElse: () => null);
//TODO: Do as above iterate through lists
              if (checkIfExists == null) {
                cat.subCategories.add(SubCategory(
                  name: sub.name,
                  percentage: sub.percentage,
                  color: sub.color,
                  description: sub.description,
                  units: []..addAll(sub.units ?? []),
                  comments: []..addAll(sub.comments ?? []),
                ));
              } else {
                checkIfExists.percentage =
                    checkIfExists.percentage + sub.percentage;
              }
            }
          }
        }
      }
    }
//    if (aggregatedCategories.isNotEmpty)
//      for (var category in aggregatedCategories) {
//        if (category.subCategories.isNotEmpty) {
//          List<SubCategory> aggregatedSubs = [];
//          List<SubCategory> catSubsProxy = [];
//
//          for (SubCategory sub in category.subCategories) {
//            aggregatedSubs = category.subCategories
//                .where((s) => s.name == sub.name)
//                .toList();
//            SubCategory subSurvivor = aggregatedSubs[0];
//            if (aggregatedSubs.length > 1) {
//              for (SubCategory subCat in aggregatedSubs) {
//                if (subCat != subSurvivor) {
//                  subSurvivor.percentage =
//                      subSurvivor.percentage + subCat.percentage;
//                  category.subCategories.remove(subCat);
//                }
//              }
//            }
//            catSubsProxy.add(subSurvivor);
//          }
//
//          category.subCategories = catSubsProxy;
////          SubCategory subSurvivor = category.subCategories[0];
////
////          List<SubCategory> isEquals = category.subCategories
////              .where((sub) => sub.name == subSurvivor.name)
////              .toList();
////
////          subSurvivor.percentage = subSurvivor.percentage / isEquals.length;
////
////          for (var subCategory in isEquals) {
////            if (subCategory != subSurvivor) {
////              subSurvivor.percentage = subSurvivor.percentage +
////                  (subCategory.percentage / isEquals.length);
////              category.subCategories.remove(subCategory);
////            }
////          }
//        }
//      }
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
