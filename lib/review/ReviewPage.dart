import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';
import 'package:provider/provider.dart';
import '../CategoryPage.dart';
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
  @override
  void initState() {
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
    Review review = widget.review;
    return MultiProvider(
      providers: [
        Provider<CategoriesBloc>.value(value: widget.categoriesBloc),
        Provider<ReviewBloc>.value(value: widget.reviewBloc),
      ],
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: isColorDark(colorLeBleu)),
            backgroundColor: colorLeBleu,
            centerTitle: true,
            title: Text(
              review.pageTitle ?? "Review",
              style: TextStyle(color: isColorDark(colorLeBleu)),
            ),
            actions: <Widget>[
              IconButton(
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
                              categoriesBloc: widget.categoriesBloc,
                            ))),
              ),
            ],
          ),
          body: SizedBox.expand(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                      itemCount: review.categories.length,
                      itemBuilder: (context, index) {
                        Category category = review.categories[index];
                        return _ReviewCategoryItem(
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
                        );
                      }),
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
          ListView(
            shrinkWrap: true,
            key: Key("subs"),
            children: category.subCategories.map((subCat) {
              return Dismissible(
                onDismissed: (direction) {
                  onSubCategoryRemoved(subCat);
                },
                key: Key(subCat.name),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorTextGrey, width: 0.5),
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
                            widget.subCategory.percentage ??
                        0,
                    decoration: BoxDecoration(
                      color: widget.subCategory.color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(20, 30),
                        bottomLeft: Radius.elliptical(20, 30),
                        topRight: widget.subCategory.percentage == 100
                            ? Radius.elliptical(20, 30)
                            : Radius.zero,
                        bottomRight: widget.subCategory.percentage == 100
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
                                      color: colorTextGrey, width: 0.5))),
                        ),
                    ],
                  ),
                ],
              );
            },
          )),
    );
  }
}
