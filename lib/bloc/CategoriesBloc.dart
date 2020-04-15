import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/SubCategory.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Category> mock = [
  Category(
    id: "1",
    name: "Føleleser",
    subCategories: [
      SubCategory(name: "Kjærlighet", color: colorLove),
      SubCategory(name: "Ro", color: colorCalmness),
      SubCategory(name: "Lykke", color: colorHappiness),
      SubCategory(name: "Frykt", color: colorFear),
      SubCategory(name: "Depresjon", color: Colors.grey[600]),
      SubCategory(name: "Sorg", color: colorSorrow),
      SubCategory(name: "Sinne", color: colorAnger),
      SubCategory(name: "Følelsesløs", color: colorDeepSea),
    ],
  ),
  Category(name: "Aktiviteter", subCategories: [
    SubCategory(name: "Jobb", color: Colors.grey),
    SubCategory(name: "Underholdning", color: Colors.yellowAccent),
    SubCategory(name: "Sove", color: colorGreen),
    SubCategory(name: "Sosial", color: Colors.cyanAccent),
    SubCategory(name: "Spise", color: Colors.green),
    SubCategory(name: "Avslapning", color: Colors.lightBlueAccent),
    SubCategory(name: "Trening", color: Colors.orange),
    SubCategory(name: "Kreativitet", color: colorLeBleu),
    SubCategory(name: "Person", color: Colors.deepPurpleAccent),
  ]),
];

class CategoriesBloc {
  ValueNotifier<List<Category>> categoryList = ValueNotifier(null);

  ChangeNotifier onRemoveCategory = ChangeNotifier();

  CategoriesBloc() {
    getCategories();
  }

  Future<void> getCategories() async {
    var prefs = await SharedPreferences.getInstance();

    var categories = prefs.getString("categories");
    if (categories != null) {
      var json = jsonDecode(categories);

      categoryList.value = (json['categories'] as List)
          ?.map((e) => e == null ? null : Category.fromJson(e as Map))
          ?.toList();
    } else {
      categoryList.value = mock;
      saveCategories();
    }
  }

  addSubCategory(
    SubCategory subCategory,
  ) async {
    assert(subCategory != null);
  }

  void removeCategory(Category category) {
    assert(category != null);
    categoryList.value.remove(category);
    onRemoveCategory.notifyListeners();
  }

  void addCategory(Category category) {
    assert(category != null);
    categoryList.value.add(category);
  }

  Future<void> saveCategories() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        "categories",
        jsonEncode(<String, dynamic>{
          'categories': categoryList.value,
        }));
  }
}
