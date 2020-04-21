import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:perspektiv/CategoryPage.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/bloc/UserBloc.dart';
import 'package:perspektiv/helper/LifeCycleEventHandler.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/Decade.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/review/ReviewListItem.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';

import 'DisplaySettings.dart';
import 'span/ReviewDaily.dart';
import 'span/ReviewMonthly.dart';
import 'span/ReviewWeekly.dart';
import 'span/ReviewYearly.dart';

class Reviewables extends StatefulWidget {
  @override
  _ReviewablesState createState() => _ReviewablesState();
}

class _ReviewablesState extends State<Reviewables> {
  CategoriesBloc _categoriesBloc;
  ReviewBloc _reviewBloc;
  UserBloc _userBloc;
  Decade _decade;

  ScrollController _scrollController = ScrollController();

  List<Provider> providers;

  bool _isLoading = true;

  int indexOfOrientation;

  @override
  void initState() {
    _categoriesBloc = CategoriesBloc();
    _reviewBloc = ReviewBloc();
    _userBloc = UserBloc();

    _categoriesBloc.categoryList.addListener(() {
      if (_reviewBloc.reviewCategory.value == null ||
          _reviewBloc.reviewCategory.value == "") {
        _reviewBloc.reviewCategory.value =
            _categoriesBloc.categoryList.value[0].name;
        _hasData();
      }
    });

    _reviewBloc.aggregated.addListener(() => setState(() {}));

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        detachedCallBack: (AppLifecycleState state) async {
          await _reviewBloc.saveReviews();
          await _categoriesBloc.saveCategories();
          print("Has Saved");
          return;
        },
        resumeCallBack: () async {}));

    providers = [
      Provider<CategoriesBloc>.value(value: _categoriesBloc),
      Provider<ReviewBloc>.value(value: _reviewBloc),
      Provider<UserBloc>.value(value: _userBloc),
    ];

    _reviewBloc.doneLoading.addListener(() {
      _decade = _reviewBloc.decade;
      _hasData();
    });

    _reviewBloc.reviewSpan.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    indexOfOrientation = MediaQuery.of(context).orientation.index;

    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        int index = _reviewBloc.reviewSpan.value.index;

        if (index != 0) {
          _reviewBloc.reviewSpan.value = ReviewSpan.values[index - 1];
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: MultiProvider(
        providers: providers,
        child: Scaffold(
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
                          ///TODO: Replace with settings feature
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: IntrinsicHeight(
                                child: IconButton(
                                    alignment: Alignment.bottomCenter,
                                    icon: Icon(
                                      Icons.layers,
                                      size: 30,
                                      color: isColorDark(colorLeBleu),
                                    ),
                                    onPressed: () {
                                      _showBottomSheet(context);
                                    }),
                              ),
                            ),
                          ),
                          _getAppBarTitle(),
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
                                            categoriesBloc: _categoriesBloc,
                                          ))),
                            ),
                          ),
                        ],
                      ))),
            ),
          ),

          // AppBar(
          //   leading: IconButton(
          //       icon: Icon(
          //         Icons.save,
          //         color: isColorDark(colorLeBleu),
          //       ),
          //       onPressed: () {
          //         _categoriesBloc.saveCategories();
          //         _reviewBloc.saveReviews();
          //       }),
          //   actions: <Widget>[

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
          //                     categoriesBloc: _categoriesBloc,
          //                   ))),
          //     ),
          //   ],
          //   centerTitle: true,
          //   backgroundColor: colorLeBleu,
          //   flexibleSpace: FlexibleSpaceBar(
          //     titlePadding: EdgeInsets.only(bottom: 8),
          //     title: _getAppBarTitle(),
          //   ),
          // ),
          body: _isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                  backgroundColor: colorHappiness,
                  valueColor: AlwaysStoppedAnimation<Color>(colorLeBleu),
                ))
              : ValueListenableBuilder(
                  valueListenable: _reviewBloc.reviewSpanListenable,
                  builder: (context, ReviewSpan reviewSpan, idk) {
                    Widget reviewContent;

                    switch (reviewSpan) {
                      case ReviewSpan.daily:
                        reviewContent = ReviewDaily(
                          reviewBloc: _reviewBloc,
                          scrollController: _scrollController,
                        );
                        break;
                      case ReviewSpan.weekly:
                        reviewContent = ReviewWeekly(
                          reviewBloc: _reviewBloc,
                          scrollController: _scrollController,
                        );

                        break;
                      case ReviewSpan.monthly:
                        reviewContent = ReviewMonthly(
                          reviewBloc: _reviewBloc,
                          scrollController: _scrollController,
                        );
                        break;
                      case ReviewSpan.yearly:
                        reviewContent = ReviewYearly(
                          reviewBloc: _reviewBloc,
                          scrollController: _scrollController,
                        );

                        break;
                      default:
                        reviewContent = Container();
                    }
                    return ListView(
                        shrinkWrap: true,
                        controller: _scrollController,
                        children: <Widget>[
                          _getNavigator(),
                          reviewContent,
                        ]);
                  }),
        ),
      ),
    );
  }

  String _getAppBarTitleText() {
    switch (_reviewBloc.reviewSpan.value) {
      case ReviewSpan.daily:
        return "Uke " + _reviewBloc.currentWeek.week.toString();
        break;
      case ReviewSpan.weekly:
        return _reviewBloc.currentMonth.monthName;
        break;
      case ReviewSpan.monthly:
        return _reviewBloc.currentYear.year.toString();
        break;
      case ReviewSpan.yearly:
        return "Reviewly";
        break;

      default:
        return "";
    }
  }

  Widget _getNavigator() {
    bool yearly = false;
    bool monthly = false;
    bool weekly = false;
    bool daily = false;

    ReviewSpan span = _reviewBloc.reviewSpan.value;

    switch (span) {
      case ReviewSpan.daily:
        {
          yearly = true;
          monthly = true;
          weekly = true;
          daily = true;
        }
        break;
      case ReviewSpan.weekly:
        {
          yearly = true;
          monthly = true;
          weekly = true;
        }
        break;
      case ReviewSpan.monthly:
        {
          yearly = true;
          monthly = true;
        }
        break;
      case ReviewSpan.yearly:
        {
          return Container();
        }
        break;

      default:
    }

    TextStyle style = TextStyle(fontSize: 20);
    TextStyle bold = style.copyWith(fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 12, bottom: 12),
      child: Container(
        height: 25,
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            if (yearly)
              InkWell(
                onTap: () {
                  _reviewBloc.reviewSpan.value = ReviewSpan.yearly;
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Reviewly",
                      style: style,
                    ),
                    Icon(Icons.arrow_right)
                  ],
                ),
              ),
            if (monthly)
              InkWell(
                onTap: () {
                  _reviewBloc.reviewSpan.value = ReviewSpan.monthly;
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _reviewBloc.currentYear.year.toString(),
                      style: span == ReviewSpan.monthly ? bold : style,
                    ),
                    if (span != ReviewSpan.monthly) Icon(Icons.arrow_right)
                  ],
                ),
              ),
            if (weekly)
              InkWell(
                onTap: () {
                  _reviewBloc.reviewSpan.value = ReviewSpan.weekly;
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _reviewBloc.currentMonth.monthName,
                      style: span == ReviewSpan.weekly ? bold : style,
                    ),
                    if (span != ReviewSpan.weekly) Icon(Icons.arrow_right)
                  ],
                ),
              ),
            if (daily)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Uke " + _reviewBloc.currentWeek.week.toString(),
                    style: bold,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _getAppBarTitle() {
    Review review;

    switch (_reviewBloc.reviewSpan.value) {
      case ReviewSpan.yearly:
        review = null;
        break;
      case ReviewSpan.monthly:
        review = _reviewBloc.currentYear.review;
        break;
      case ReviewSpan.weekly:
        review = _reviewBloc.currentMonth.review;

        break;
      case ReviewSpan.daily:
        review = _reviewBloc.currentWeek.review;

        break;
    }

    Size size = MediaQuery.of(context).size;

    Widget titleText = Container(
      alignment: Alignment.center,
      width: size.width / 1.8,
      child: Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(
            _getAppBarTitleText(),
            style: TextStyle(color: Colors.white, fontSize: 24),
          )),
    );
    if (review == null) {
      return titleText;
    }

    return ReviewListItem(
      pageTitle: review.title,
      size: Size(
          size.width / 1.8, size.height / (indexOfOrientation == 0 ? 14 : 7)),
      review: review,
      reviewBloc: _reviewBloc,
      itemAmount: 1,
    );
  }

  void _hasData() {
    if (_decade != null &&
        (_reviewBloc.reviewCategory.value != null &&
            _reviewBloc.reviewCategory.value != "")) if (_isLoading == true)
      setState(() {
        _isLoading = false;
      });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: true, // <--- this line
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(20, 30),
                topRight: Radius.elliptical(20, 30))),
        context: context,
        builder: (builder) {
          return DisplaySettings(
            reviewBloc: _reviewBloc,
          );
        });
  }
}
