import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Month.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ReviewListItem extends StatefulWidget {
  final Category category;
  final int itemAmount;

  const ReviewListItem({Key key, this.category, this.itemAmount})
      : assert(itemAmount != null),
        assert(category != null),
        super(key: key);

  @override
  ReviewListItemState createState() => ReviewListItemState();
}

class ReviewListItemState extends State<ReviewListItem> {
  bool init = true;

  CategoriesBloc _categoriesBloc;

  Category theCategoryView;

  double maxWidth;

  Size size;

  @override
  void initState() {
    theCategoryView = widget.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    maxWidth = size.width - 24;

    if (init)
      WidgetsBinding.instance.addPostFrameCallback((_) => Timer(
          Duration(milliseconds: 200), () => setState(() => init = false)));

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(20, 30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: theCategoryView.subCategories
            .map((sub) => _getSubCategoryItem(sub))
            .toList(),
      ),
    );
  }

  Widget _getSubCategoryItem(SubCategory sub) {
    BorderRadius fillBorderRadius;
    BorderRadius bgBorderRadius;

    bool subIsLast = sub == theCategoryView.subCategories.last;

//    sub.percentage = 10;

    double widthAsPercentage =
        ((maxWidth / theCategoryView.subCategories.length) / 100);

    double fillWidth = widthAsPercentage * sub.percentage;

    double remainingWidth = widthAsPercentage * (100 - sub.percentage);

    if (sub == theCategoryView.subCategories.first) {
      fillBorderRadius = BorderRadius.only(
          topLeft: Radius.elliptical(20, 30),
          bottomLeft: Radius.elliptical(20, 30));
      bgBorderRadius = fillBorderRadius;
    } else if (subIsLast && sub.percentage >= 89) {
      fillBorderRadius = BorderRadius.only(
          topRight: Radius.elliptical(20, 30),
          bottomRight: Radius.elliptical(20, 30));
    }

    if (subIsLast) {
      bgBorderRadius = BorderRadius.only(
          topRight: Radius.elliptical(20, 30),
          bottomRight: Radius.elliptical(20, 30));
    }

    if (theCategoryView.subCategories.length == 1) {
      bgBorderRadius = BorderRadius.all(
        Radius.elliptical(20, 30),
      );
      fillBorderRadius = bgBorderRadius;
    }

    double itemWidth = maxWidth / theCategoryView.subCategories.length;
    double itemHeight = (size.height / widget.itemAmount) - 12;

    return Container(
      width: itemWidth,
      height: itemHeight,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(borderRadius: fillBorderRadius),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: bgBorderRadius,
                color: Colors.black.withOpacity(0.3)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: fillBorderRadius,
              ),
              duration: Duration(milliseconds: 500),
              height: (size.height / widget.itemAmount) - 12,
              width: init ? 0 : fillWidth,
            ),
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.elliptical(20, 30),
              ),
              color: Colors.black.withOpacity(0.2),
            ),
            child: Text(
              sub.name,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: TextStyle(color: isColorDark(sub.color)),
            ),
          )
        ],
      ),
    );
  }
}
