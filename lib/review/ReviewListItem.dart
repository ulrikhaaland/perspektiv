import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/model/Aggregated.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Month.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';
import 'package:perspektiv/review/ReviewPage.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ReviewListItem extends StatefulWidget {
  final int itemAmount;
  final Review review;
  final String pageTitle;
  final ReviewBloc reviewBloc;
  final Size size;
  final List<Category> reviewCategories;
  final bool isAggregated;
  final Aggregated aggregated;

  const ReviewListItem(
      {Key key,
      this.itemAmount,
      this.review,
      this.reviewBloc,
      this.size,
      this.pageTitle,
      this.reviewCategories,
      this.aggregated,
      this.isAggregated = false})
      : assert(itemAmount != null),
        assert(review != null),
        super(key: key);

  @override
  ReviewListItemState createState() => ReviewListItemState();
}

class ReviewListItemState extends State<ReviewListItem> {
  bool init = true;

  Category theCategoryView;

  @override
  void initState() {
    if (widget.review != null)
      widget.review.onAddCategory.addListener(() {
        if (mounted) setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    widget.review.onAddCategory.removeListener(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categoryList = widget.isAggregated == false
        ? (widget.reviewCategories ?? widget.review.categories)
        : widget.aggregated.categories;
    theCategoryView = categoryList.firstWhere(
        (cat) => cat.name == widget.reviewBloc.reviewCategory.value,
        orElse: () => Category(subCategories: [
              SubCategory(
                  name: "Ikke definert",
                  color: Colors.grey,
                  percentage: widget.isAggregated == false
                      ? 100
                      : widget.aggregated.largestSubCatPercentage),
            ]));

    if (init)
      WidgetsBinding.instance
          .addPostFrameCallback((_) => Timer(Duration(milliseconds: 200), () {
                if (mounted) setState(() => init = false);
              }));

    Widget _subCategoryItems = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: theCategoryView.subCategories
          .map((sub) => _getSubCategoryItem(sub,
              isFirst: theCategoryView.subCategories.first == sub))
          .toList(),
    );

    if (widget.pageTitle != null)
      _subCategoryItems = RaisedButton(
        elevation: 10,
        focusElevation: 20,
        color: colorLeBleu,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.elliptical(20, 30),
          ),
        ),
        onPressed: () {
          var reviewBloc = Provider.of<ReviewBloc>(context, listen: false);
          var categoriesBloc =
              Provider.of<CategoriesBloc>(context, listen: false);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ReviewPage(
                    review: widget.review,
                    reviewBloc: reviewBloc,
                    categoriesBloc: categoriesBloc,
                  )));
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _subCategoryItems,
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.elliptical(20, 30),
                ),
                color: Colors.black.withOpacity(0.2),
              ),
              child: Text(
                widget.pageTitle,
                textWidthBasis: TextWidthBasis.parent,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            )
          ],
        ),
      );

//    if (widget.size == null)
    return Align(alignment: Alignment.center, child: _subCategoryItems);
//      else return _subCategoryItems;
  }

  Widget _getSubCategoryItem(SubCategory sub, {bool isFirst}) {
    BorderRadius fillBorderRadius;
    BorderRadius bgBorderRadius;

    bool subIsLast = false;
    if (sub == theCategoryView.subCategories.last &&
        theCategoryView.subCategories.length != 1) {
      subIsLast = true;
    }

//    sub.percentage = 10;

    double divideByBiggestPercentage = 0;

    if (widget.isAggregated == true) {
      divideByBiggestPercentage = widget.aggregated.largestSubCatPercentage;
//      for (SubCategory sub in theCategoryView.subCategories) {
//        if (sub.percentage > divideByBiggestPercentage)
//          divideByBiggestPercentage = sub.percentage;
//      }
    } else {
      divideByBiggestPercentage = 100;
    }

    if (sub == theCategoryView.subCategories.first) {
      fillBorderRadius = BorderRadius.only(
          topLeft: Radius.elliptical(20, 30),
          bottomLeft: Radius.elliptical(20, 30));
      bgBorderRadius = fillBorderRadius;
    } else if (subIsLast &&
        sub.percentage >= ((divideByBiggestPercentage / 100) * 89)) {
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
      if (divideByBiggestPercentage == sub.percentage)
        fillBorderRadius = bgBorderRadius;
    }

    Size size = widget.size ?? MediaQuery.of(context).size;

    double maxWidth = size.width;

    if (widget.size == null) maxWidth -= 32;

    double widthAsPercentage =
        ((maxWidth / theCategoryView.subCategories.length) /
            divideByBiggestPercentage);

    double fillWidth = widthAsPercentage *
        (widget.pageTitle != null
            ? (isFirst == true && sub.percentage == 10
                ? (sub.percentage + 11)
                : sub.percentage)
            : sub.percentage);

    double itemWidth = size.width;
    double itemHeight = size.height;

    itemWidth = maxWidth / theCategoryView.subCategories.length;

    if (widget.size == null) {
      itemHeight = (size.height / widget.itemAmount) - 12;

      if (itemHeight < 50)
        itemHeight = 50;
      else if (itemHeight > 100) itemHeight = 100;
    }

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
            width: itemWidth,
            decoration: BoxDecoration(
                borderRadius: bgBorderRadius, color: Color(0xFFE8E8E8)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: sub.color,
                borderRadius: fillBorderRadius,
              ),
              duration: Duration(milliseconds: 500),
              height: itemHeight,
              width: init ? 0 : fillWidth,
            ),
          ),
          if (widget.pageTitle == null)
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorBackGround,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(
                  Radius.elliptical(20, 30),
                ),
                color: isDark(
                  color: sub.color,
                )
                    ? Colors.white
                    : Colors.black.withOpacity(0.3),
              ),
              child: Text(
                sub.name,
                textWidthBasis: TextWidthBasis.parent,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: sub.color),
              ),
            )
        ],
      ),
    );
  }
}
