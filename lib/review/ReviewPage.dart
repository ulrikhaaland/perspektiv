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
import 'ValueDisplayer.dart';

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
      _rebuild();
      _scrollToMaxExtent();
    });

    widget.review.onAddSubCategory.addListener(() {
      _rebuild();
    });
    widget.review.onAddComment.addListener(() {
      _rebuild();
      _scrollToMaxExtent();
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.review.onAddCategory.removeListener(() {
      _rebuild();
      _scrollToMaxExtent();
    });
    widget.review.onAddSubCategory.removeListener(() {
      _rebuild();
    });
    widget.review.onAddComment.removeListener(() {
      _rebuild();
      _scrollToMaxExtent();
    });
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
                        ListView(
                          controller: _scrollController,
                          shrinkWrap: true,
                          children: review.categories
                              .map((category) => Dismissible(
                                    key: Key(category.hashCode.toString()),
                                    onDismissed: (_) {
                                      review.categories.remove(category);
                                    },
                                    child: _ReviewCategoryItem(
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
                                    ),
                                  ))
                              .toList(),
                        ),
                        Container(
                          height: 50,
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

  void _scrollToMaxExtent() {
    Timer(Duration(milliseconds: 100), () {
      double position = _scrollController.positions.first.maxScrollExtent - 50;
      _scrollController.positions.first.animateTo(position,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    });
  }

  void _rebuild() {
    if (mounted) setState(() {});
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          ValueDisplayer(
            category: category,
            onSubCategoryRemoved: (sub) => onSubCategoryRemoved(sub),
          ),
        ],
      ),
    );
  }
}
