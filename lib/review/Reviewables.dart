import 'package:flutter/material.dart';
import 'package:perspektiv/CategoryPage.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/bloc/UserBloc.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/Decade.dart';
import 'package:provider/provider.dart';

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
      }
    });

    providers = [
      Provider<CategoriesBloc>.value(value: _categoriesBloc),
      Provider<ReviewBloc>.value(value: _reviewBloc),
      Provider<UserBloc>.value(value: _userBloc),
    ];

    _reviewBloc.doneLoading.addListener(() {
      setState(() {
        _decade = _reviewBloc.decade;
      });
    });

    _reviewBloc.reviewSpan.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.save,
                  color: isColorDark(Colors.white),
                ),
                onPressed: () {
                  _categoriesBloc.saveCategories();
                  _reviewBloc.saveReviews();
                }),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.filter_vintage,
                    color: isColorDark(Colors.white),
                  ),
                  onPressed: () {
                    _categoriesBloc.saveCategories();
                    _reviewBloc.saveReviews();
                  }),
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
                              categoriesBloc: _categoriesBloc,
                            ))),
              ),
            ],
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              _getTitle(),
              style: TextStyle(color: isColorDark(Colors.white)),
            ),
          ),
          body: _decade == null
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

  String _getTitle() {
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

    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 12),
      child: Container(
        height: 20,
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
                      style: TextStyle(
                          fontWeight: span == ReviewSpan.monthly
                              ? FontWeight.bold
                              : null),
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
                      style: TextStyle(
                          fontWeight: span == ReviewSpan.weekly
                              ? FontWeight.bold
                              : null),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
