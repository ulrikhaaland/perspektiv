import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:provider/provider.dart';

import '../CategoryItem.dart';
import '../main.dart';

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
    return DefaultTabController(
      length: _categories.length,
      child: Container(
        height: size.height,
        width: size.width,
        child: DraggableScrollableSheet(
            expand: false,
            maxChildSize: 0.4,
            minChildSize: 0.2,
            initialChildSize: 0.2,
            builder: (context, sheetController) {
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
                        pinned: true,
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
                          height: 12,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          height: (size.height / 10) * 5,
                          child: TabBarView(
                            children: _categories.map((category) {
                              return Align(
                                alignment: Alignment.topCenter,
                                child: _ReviewSheetCollection(
                                  key: Key(category.name),
                                  category: category,
                                  review: widget.review,
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

class _ReviewSheetCollection extends StatelessWidget {
  final Category category;
  final Review review;

  const _ReviewSheetCollection({Key key, this.category, this.review})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 8,
      runSpacing: 16,
      children: category.subCategories.map((subCat) {
        return InkWell(
            onTap: () => review.onTapSubCategory(
                category: category, subCategory: subCat),
            child: SubCategoryItem(key: Key(subCat.name), subCategory: subCat));
      }).toList(),
    );
  }
}
