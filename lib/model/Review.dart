import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/SubCategory.dart';

class Review {
  String pageTitle;
  String word;
  String sentence;
  String paragraph;
  List<Category> categories;

  bool tapDown;

  ChangeNotifier onAddCategory = ChangeNotifier();

  ValueNotifier<SubCategory> onSubChanged = ValueNotifier(null);

  Review(
      {this.word,
      this.sentence,
      this.paragraph,
      this.categories,
      this.pageTitle});

  void onTapSubCategory(
      {Category category, SubCategory subCategory, int millis}) {
    assert(category != null && subCategory != null);

    SubCategory checkSubCat;

    Category checkCat = categories
        .firstWhere((cat) => cat.name == category.name, orElse: () => null);

    if (checkCat == null) {
      checkSubCat = SubCategory(
          name: subCategory.name, color: subCategory.color, percentage: 10);
      Category newCategory = Category(
        name: category.name,
        subCategories: [checkSubCat],
      );
      categories.add(newCategory);
    } else {
      checkSubCat = checkCat.subCategories.firstWhere(
          (subCat) => subCat.name == subCategory.name,
          orElse: () => null);
      if (checkSubCat == null) {
        checkSubCat = SubCategory(
            name: subCategory.name, color: subCategory.color, percentage: 10);
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
}
