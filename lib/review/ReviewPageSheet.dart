import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Comment.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:provider/provider.dart';

import '../CategoryItem.dart';
import '../main.dart';
import '../main.dart';
import '../main.dart';
import '../main.dart';
import '../main.dart';
import '../model/Category.dart';
import '../model/Category.dart';
import '../model/SubCategory.dart';

class ReviewPageSheet extends StatefulWidget {
  final Review review;

  const ReviewPageSheet({
    Key key,
    this.review,
  })  : assert(review != null),
        super(key: key);

  @override
  _ReviewPageSheetState createState() => _ReviewPageSheetState();
}

class _ReviewPageSheetState extends State<ReviewPageSheet> {
  CategoriesBloc _categoriesBloc;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (_categoriesBloc == null)
      _categoriesBloc = Provider.of<CategoriesBloc>(context);

    List<Category> _categories = _categoriesBloc.categoryList.value;

    Review review = widget.review;
    return DefaultTabController(
      length: _categories.length,
      child: Container(
        height: size.height,
        width: size.width,
        child: DraggableScrollableSheet(
            // expand: false,
            maxChildSize: 0.4,
            minChildSize: 0.2,
            initialChildSize: 0.2,
            builder: (context, sheetController) {
              // sheetController.animateTo(offset)
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(20, 30),
                          topRight: Radius.elliptical(20, 30))),
                  child: CustomScrollView(
                    controller: sheetController,
                    slivers: <Widget>[
                      SliverAppBar(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(20, 30),
                                topRight: Radius.elliptical(20, 30))),
                        backgroundColor: Color(0xFFE8E8E8),
                        titleSpacing: 0,
                        automaticallyImplyLeading: false,
                        stretch: true,
                        pinned: true,
                        leading: Container(
                          width: 50,
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.chat,
                            color: Colors.transparent,
                          ),
                        ),
                        actions: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 50,
                            child: IconButton(
                              
                              alignment: Alignment.centerLeft,
                              icon: Icon(
                                Icons.chat,
                                color: colorLeBleu,
                                size: 30,
                              ),
                              onPressed: review.addComment,
                            ),
                          ),
                        ],
                        title: Column(
                          children: <Widget>[
                            Container(
                              height: 8,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 4,
                              width: 28,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(20, 30),
                                ),
                              ),
                            ),
                            TabBar(
                                indicatorPadding: EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
                                indicatorColor: colorLeBleu,
                                isScrollable:
                                    _categories.length > 4 ? true : false,
                                labelColor: colorTextGrey,
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                                unselectedLabelStyle:
                                    TextStyle(color: colorTextGrey),
                                tabs: _categories.map((category) {
                                  return Tab(
                                    text: category.name ?? "N/A",
                                  );
                                }).toList()),
                          ],
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                          height: 16,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 8 , left: 8, right: 8),
                          alignment: Alignment.topLeft,
                          height: (size.height / 10) * 3,
                          child: TabBarView(
                            children: _categories.map((category) {
                              return Align(
                                alignment: Alignment.topCenter,
                                child: _ReviewSheetCollection(
                                  key: Key(category.name),
                                  scrollController: sheetController,
                                  category: category,
                                  review: review,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ])),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class _ReviewSheetCollection extends StatefulWidget {
  final Category category;
  final Review review;
  final ScrollController scrollController;

  _ReviewSheetCollection(
      {Key key, this.category, this.review, this.scrollController})
      : assert(category != null),
        assert(scrollController != null),
        assert(review != null),
        super(key: key);

  @override
  __ReviewSheetCollectionState createState() => __ReviewSheetCollectionState();
}

class __ReviewSheetCollectionState extends State<_ReviewSheetCollection> {
  @override
  Widget build(BuildContext context) {
    //TODO: Add gridviewbuilder

    return GridView.builder(
        controller: widget.scrollController,
        itemCount: widget.category.subCategories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.75),
        itemBuilder: (context, index) {
          SubCategory subCat = widget.category.subCategories[index];
          return GestureDetector(
            onTapDown: (_) {
              widget.review.tapDown = true;
              widget.review.onTapSubCategory(
                  category: widget.category, subCategory: subCat);
            },
            onTapUp: (_) {
              widget.review.tapDown = false;
            },
            onVerticalDragStart: (_) {
              widget.review.tapDown = false;
            },
            onHorizontalDragStart: (_) {
              widget.review.tapDown = false;
            },
            child: InkWell(
                // onTapDown: (details) {
                //   print("tap down");
                // },
                // onTapCancel: () {
                //   print("cancel");
                // },
                // onTap: () => review.onTapSubCategory(
                //     category: category, subCategory: subCat),
                child: SubCategoryItem(
                    key: Key(subCat.name), subCategory: subCat)),
          );
        });
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 8,
      runSpacing: 16,
      children: widget.category.subCategories.map((subCat) {
        return GestureDetector(
          onTapDown: (_) {
            widget.review.tapDown = true;
            widget.review.onTapSubCategory(
                category: widget.category, subCategory: subCat);
          },
          onTapUp: (_) {
            widget.review.tapDown = false;
          },
          onVerticalDragStart: (_) {
            widget.review.tapDown = false;
          },
          onHorizontalDragStart: (_) {
            widget.review.tapDown = false;
          },
          child: InkWell(
              // onTapDown: (details) {
              //   print("tap down");
              // },
              // onTapCancel: () {
              //   print("cancel");
              // },
              // onTap: () => review.onTapSubCategory(
              //     category: category, subCategory: subCat),
              child:
                  SubCategoryItem(key: Key(subCat.name), subCategory: subCat)),
        );
      }).toList(),
    );
  }
}
