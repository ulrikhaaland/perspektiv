import 'package:flutter/cupertino.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/SubCategory.dart';

class Review {
  String pageTitle;
  String word;
  String sentence;
  String paragraph;
  List<Category> categories;

  ChangeNotifier onAddCategory = ChangeNotifier();

  ValueNotifier<SubCategory> onSubChanged = ValueNotifier(null);

  Review(
      {this.word,
      this.sentence,
      this.paragraph,
      this.categories,
      this.pageTitle});

  void onTapSubCategory({Category category, SubCategory subCategory}) {
    assert(category != null && subCategory != null);

    Category checkCat = categories
        .firstWhere((cat) => cat.name == category.name, orElse: () => null);

    if (checkCat == null) {
      Category newCategory = Category(
        name: category.name,
        subCategories: [
          subCategory..percentage = 10,
        ],
      );
      categories.add(newCategory);
      onAddCategory.notifyListeners();
    } else {
      SubCategory checkSubCat = checkCat.subCategories.firstWhere(
          (subCat) => subCat.name == subCategory.name,
          orElse: () => null);
      if (checkSubCat == null) {
        checkCat.subCategories.add(subCategory..percentage = 10);
      } else if (subCategory.percentage < 100) {
        subCategory.percentage += 10;
      } else if (subCategory.percentage > 0) {
        subCategory.percentage -= 10;
      }
      onSubChanged.value = subCategory;
      onAddCategory.notifyListeners();
    }
  }
}
