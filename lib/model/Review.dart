import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/SubCategory.dart';
import 'package:json_annotation/json_annotation.dart';
import 'Category.dart';
import 'Comment.dart';

part 'Review.g.dart';

@JsonSerializable(anyMap: true)
class Review {
  String title;
  String word;
  String sentence;
  String paragraph;
  DateTime lastEdited;
  String id;
  ReviewSpan reviewSpan;
  List<Category> categories;
  List<Comment> comments;
  @JsonKey(ignore: true)
  bool tapDown;
  @JsonKey(ignore: true)
  ChangeNotifier onAddCategory = ChangeNotifier();
  @JsonKey(ignore: true)
  ChangeNotifier onAddComment = ChangeNotifier();
  @JsonKey(ignore: true)
  ValueNotifier<SubCategory> onSubChanged = ValueNotifier(null);

  Review(
      {this.word,
      this.sentence,
      this.id,
      this.paragraph,
      this.categories,
      this.title,
      this.lastEdited,
      this.reviewSpan,
      this.comments});

  void addComment() {
    Comment comment = Comment(comment: "", init: true);
    if (categories.isEmpty) {
      comments.add(comment..label = title);
    } else {
      Category latestCategory = categories.last;

      if (latestCategory.subCategories.isEmpty) {
        latestCategory.comments.add(comment..label = latestCategory.name);
      } else {
        SubCategory latestSubCategory = latestCategory.subCategories.last;
        latestSubCategory.comments.add(comment..label = latestSubCategory.name);
      }
    }
    onAddComment.notifyListeners();
  }

  void onTapSubCategory(
      {Category category, SubCategory subCategory, int millis}) {
    assert(category != null && subCategory != null);

    SubCategory checkSubCat;

    Category checkCat = categories
        .firstWhere((cat) => cat.name == category.name, orElse: () => null);

    if (checkCat == null) {
      checkSubCat = SubCategory(
          name: subCategory.name,
          color: subCategory.color,
          percentage: 10,
          comments: []);
      Category newCategory = Category(
        name: category.name,
        subCategories: [checkSubCat],
        comments: [],
      );
      categories.add(newCategory);
    } else {
      checkSubCat = checkCat.subCategories.firstWhere(
          (subCat) => subCat.name == subCategory.name,
          orElse: () => null);
      if (checkSubCat == null) {
        checkSubCat = SubCategory(
            name: subCategory.name,
            color: subCategory.color,
            percentage: 10,
            comments: []);
        checkCat.subCategories.add(checkSubCat);
      } else if (checkSubCat.percentage < 100) {
        checkSubCat.percentage += 10;
      } else if (checkSubCat.percentage == 100) {
        checkSubCat.percentage = 0;
      }

      onSubChanged.value = checkSubCat;
    }
    Timer(Duration(milliseconds: millis ?? 300), () {
      if (checkSubCat.percentage == 100) {
        tapDown = false;
        HapticFeedback.heavyImpact();
      }

      if (tapDown) {
        onTapSubCategory(
            category: category,
            subCategory: checkSubCat,
            millis: (millis ?? 300) - 20);
        HapticFeedback.lightImpact();
      }
    });

    onAddCategory.notifyListeners();
  }

  factory Review.fromJson(Map json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
