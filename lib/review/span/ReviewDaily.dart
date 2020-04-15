import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Day.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';
import 'package:perspektiv/model/Week.dart';
import 'package:perspektiv/review/ReviewPage.dart';
import 'package:provider/provider.dart';

import '../../helper.dart';
import '../../main.dart';
import '../ReviewListItem.dart';

class ReviewDaily extends StatefulWidget {
  final ReviewBloc reviewBloc;
  final ScrollController scrollController;

  const ReviewDaily({Key key, this.reviewBloc, this.scrollController})
      : super(key: key);

  @override
  _ReviewDailyState createState() => _ReviewDailyState();
}

class _ReviewDailyState extends State<ReviewDaily> {
  var _categoriesBloc;

  @override
  Widget build(BuildContext context) {
    Week week = widget.reviewBloc.currentWeek;

    assert(week != null);

    Size _size = MediaQuery.of(context).size;

    if (_categoriesBloc == null)
      _categoriesBloc = Provider.of<CategoriesBloc>(context);

    double listItemHeight = _size.height / week.days.length - 42;

    if (listItemHeight < 50) listItemHeight = 50;

    return ListView.builder(
        controller: widget.scrollController,
        shrinkWrap: true,
        itemCount: week.days.length,
        itemBuilder: (context, index) {
          Day day = week.days[index];
          Review review = day.review ??
              Review(
                  reviewSpan: ReviewSpan.daily,
                  categories: [],
                  pageTitle: getFormattedDate(date: day.dayDate),
                  comments: [],
                  id: widget.reviewBloc.currentYear.year +
                      widget.reviewBloc.currentMonth.month +
                      widget.reviewBloc.currentWeek.week +
                      day.day);
          if (day.review == null) {
            day.review = review;
          }
          if (widget.reviewBloc.reviews.contains(review) == false) {
            widget.reviewBloc.reviews.add(review);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Text(
                  day.dayName,
                  style: TextStyle(
                      color: colorTextGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReviewPage(
                      key: Key(day.dayDate.toIso8601String()),
                      review: day.review,
                      categoriesBloc: _categoriesBloc,
                      reviewBloc: widget.reviewBloc,
                    ),
                  ));
                },
                child: Container(
//                  height: listItemHeight,
                  child: ReviewListItem(
                    key: Key(day.dayDate.toIso8601String()),
                    review: review,
                    reviewBloc: widget.reviewBloc,
                    itemAmount: week.days.length,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
