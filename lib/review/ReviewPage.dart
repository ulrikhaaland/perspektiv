import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Comment.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';
import 'package:perspektiv/review/ReviewInput.dart';
import 'package:provider/provider.dart';
import '../CategoryPage.dart';
import '../model/Category.dart';
import 'ReviewPageSheet.dart';

class ReviewPage extends StatefulWidget {
  final Review review;
  final CategoriesBloc categoriesBloc;
  final ReviewBloc reviewBloc;

  const ReviewPage({Key key, this.review, this.categoriesBloc, this.reviewBloc})
      : assert(review != null),
        super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    widget.review.onAddCategory.addListener(() {
      if (mounted)
        setState(() {
          //TODO: Add scrollfeedback on add comment
        });
    });
    widget.review.onAddComment.addListener(() {
      if (mounted) {
        setState(() {
          //TODO: Add scrollfeedback on add comment
        });
         Timer(
           Duration(milliseconds: 200),
           () => _scrollController.animateTo(
               _scrollController.position.maxScrollExtent,
               duration: Duration(milliseconds: 250),
               curve: Curves.linear),
         );
      }
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
    Size size = MediaQuery.of(context).size;

    int indexOfOrientation = MediaQuery.of(context).orientation.index;
    Review review = widget.review;

    return MultiProvider(
      providers: [
        Provider<CategoriesBloc>.value(value: widget.categoriesBloc),
        Provider<ReviewBloc>.value(value: widget.reviewBloc),
        Provider<Review>.value(value: review),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size(size.width, 80),
              child: Material(
                elevation: 10,
                child: SizedBox.expand(
                    child: Container(
                        padding: EdgeInsets.only(
                            top: indexOfOrientation == 0 ? 32 : 0),
                        color: colorLeBleu,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            Container(
                              width: size.width / 1.8,
                              child: Text(
                                review.title ?? "Review",
                                style: TextStyle(
                                    color: isColorDark(colorLeBleu),
                                    fontSize: 24),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                icon: Icon(
                                  Icons.category,
                                  size: 30,
                                  color: colorHappiness,
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryPage(
                                              key: Key("categoryPage"),
                                              categoriesBloc:
                                                  widget.categoriesBloc,
                                            ))),
                              ),
                            ),
                          ],
                        ))),
              ),
            ),

            // AppBar(
            //   iconTheme: IconThemeData(color: isColorDark(colorLeBleu)),
            //   backgroundColor: colorLeBleu,
            //   centerTitle: true,
            //   title: Text(
            //     review.title ?? "Review",
            //     style: TextStyle(color: isColorDark(colorLeBleu)),
            //   ),
            //   actions: <Widget>[
            //     IconButton(
            //       icon: Icon(
            //         Icons.save,
            //         size: 30,
            //         color: Colors.white,
            //       ),
            //       onPressed: () {
            //         widget.reviewBloc.saveReviews();
            //         widget.categoriesBloc.saveCategories();
            //       },
            //     ),
            //     IconButton(
            //       icon: Icon(
            //         Icons.category,
            //         size: 30,
            //         color: colorHappiness,
            //       ),
            //       onPressed: () => Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => CategoryPage(
            //                     key: Key("categoryPage"),
            //                     categoriesBloc: widget.categoriesBloc,
            //                   ))),
            //     ),
            //   ],
            // ),
            body: SizedBox.expand(
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView(
                      controller: _scrollController,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 16, right: 16),
                          child: ListView(
                            shrinkWrap: true,
                            children: review.comments
                                .map((comment) => Dismissible(
                                      key: Key(comment.hashCode.toString()),
                                      onDismissed: (dir) =>
                                          review.comments.remove(comment),
                                      child: ReviewInput(
                                        commentList: review.comments,
                                        comment: comment,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        Column(
                          children: review.categories
                              .map((category) => _ReviewCategoryItem(
                                    onSubCategoryRemoved: (subCat) {
                                      category.subCategories.remove(subCat);
                                      if (category.subCategories.isEmpty) {
                                        setState(() {
                                          review.categories.remove(category);
                                        });
                                      }
                                    },
                                    key: Key(category.name),
                                    category: category,
                                  ))
                              .toList(),
                        ),
                        Container(
                          height: 200,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: ReviewPageSheet(
                      review: review,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class _ReviewCategoryItem extends StatelessWidget {
  final Category category;
  final void Function(SubCategory subCategory) onSubCategoryRemoved;

  const _ReviewCategoryItem({
    Key key,
    this.category,
    this.onSubCategoryRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            category.name,
            style: TextStyle(
                color: colorTextGrey,
                fontWeight: FontWeight.w500,
                fontSize: 22),
          ),
          Divider(),
          Column(
            key: Key("subs"),
            children: category.subCategories.map((subCat) {
              return Dismissible(
                onDismissed: (direction) {
                  onSubCategoryRemoved(subCat);
                },
                key: Key(subCat.hashCode.toString()),
                child: _ReviewSubCategoryItem(
                  key: Key(subCat.name),
                  subCategory: subCat,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ReviewSubCategoryItem extends StatefulWidget {
  final SubCategory subCategory;

  const _ReviewSubCategoryItem({
    Key key,
    this.subCategory,
  }) : super(key: key);

  @override
  __ReviewSubCategoryItemState createState() => __ReviewSubCategoryItemState();
}

class __ReviewSubCategoryItemState extends State<_ReviewSubCategoryItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double itemHeight = size.height / 14;

    SubCategory subCategory = widget.subCategory;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorBackGround, width: 1),
                borderRadius: BorderRadius.all(Radius.elliptical(20, 30)),
              ),
              width: size.width,
              height: itemHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        width: (constraints.maxWidth / 100) *
                                subCategory.percentage ??
                            0,
                        decoration: BoxDecoration(
                          color: subCategory.color,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(20, 30),
                            bottomLeft: Radius.elliptical(20, 30),
                            topRight: subCategory.percentage == 100
                                ? Radius.elliptical(20, 30)
                                : Radius.zero,
                            bottomRight: subCategory.percentage == 100
                                ? Radius.elliptical(20, 30)
                                : Radius.zero,
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          for (var i = 0; i < 9; i++)
                            Container(
                              width: constraints.maxWidth / 10,
                              height: itemHeight,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color:
                                              isDark(color: subCategory.color)
                                                  ? colorBackGround
                                                  : Colors.grey,
                                          width: 1))),
                            ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
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
                              color: subCategory.color,
                            )
                                ? Colors.white
                                : Colors.black.withOpacity(0.3),
                          ),
                          child: Text(
                            subCategory.name,
                            textWidthBasis: TextWidthBasis.parent,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: subCategory.color),
                          ),
                        ),
                      )
                    ],
                  );
                },
              )),
        ),
        Column(
          children: subCategory.comments
              .map((comment) => Dismissible(
                    key: Key(comment.hashCode.toString()),
                    onDismissed: (val) {
                      subCategory.comments.remove(comment);
                    },
                    child: ReviewInput(
                      commentList: subCategory.comments,
                      comment: comment,
                    ),
                  ))
              .toList(),
        )
      ],
    );
  }
}
