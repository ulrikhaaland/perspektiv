import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/helper.dart';
import 'package:perspektiv/model/Month.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/Week.dart';
import '../../main.dart';
import '../ReviewListItem.dart';

class ReviewWeekly extends StatefulWidget {
  final ReviewBloc reviewBloc;
  final ScrollController scrollController;

  const ReviewWeekly({Key key, this.reviewBloc, this.scrollController})
      : super(key: key);

  @override
  _ReviewWeeklyState createState() => _ReviewWeeklyState();
}

class _ReviewWeeklyState extends State<ReviewWeekly> {
  Month month;

  @override
  Widget build(BuildContext context) {
    month = widget.reviewBloc.currentMonth;
    assert(month != null);
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: ListView.builder(
          shrinkWrap: true,
          controller: widget.scrollController,
          itemCount: month.weeks.length,
          itemBuilder: (context, index) {
            Week week = month.weeks[index];
            week.aggregate();
            Review review = week.review ??
                Review(
                    comments: [],
                    title: "Uke " + week.week,
                    reviewSpan: ReviewSpan.weekly,
                    categories: [],
                    id: widget.reviewBloc.currentYear.year +
                        widget.reviewBloc.currentMonth.month +
                        addToZero(week.week));
            if (week.review == null) week.review = review;
            if (widget.reviewBloc.reviews.contains(review) == false) {
              widget.reviewBloc.reviews.add(review);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 12),
                  child: _getReviewListItemTitle(review: review, week: week),
                ),
                InkWell(
                  onTap: () {
                    widget.reviewBloc.currentWeek = week;
                    widget.reviewBloc.reviewSpan.value = ReviewSpan.daily;
                  },
                  child: Container(
                    height: 100,
                    child: ReviewListItem(
                      reviewCategories:
                          widget.reviewBloc.aggregated.value == false
                              ? review.categories
                              : week.aggregatedCategories,
                      reviewBloc: widget.reviewBloc,
                      review: review,
                      itemAmount: month.weeks.length,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _getReviewListItemTitle({Review review, Week week}) {
    TextStyle style = TextStyle(
        color: colorTextGrey, fontWeight: FontWeight.bold, fontSize: 22);
    if (widget.reviewBloc.aggregated.value == false) {
      return Text(
        review.title,
        style: style,
      );
    } else {
      String lastDayNumber = "";
      if (week.days.length > 1) {
        lastDayNumber = "-" + week.days.last.day;
      }
      return RichText(
          text: TextSpan(children: [
        TextSpan(
          text: "Aggregert ",
          style: style,
        ),
        if (week.days.first.review != null)
          TextSpan(
              text: week.days.first.day + lastDayNumber + " " + month.monthName,
              style: style)
        else
          TextSpan(text: "Uke " + week.week, style: style)
      ]));
    }
  }
}
