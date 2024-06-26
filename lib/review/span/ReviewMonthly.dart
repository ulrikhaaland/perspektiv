import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/helper.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/Month.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/Year.dart';
import '../ReviewListItem.dart';

class ReviewMonthly extends StatefulWidget {
  final ReviewBloc reviewBloc;
  final ScrollController scrollController;

  const ReviewMonthly({Key key, this.reviewBloc, this.scrollController})
      : super(key: key);

  @override
  _ReviewMonthlyState createState() => _ReviewMonthlyState();
}

class _ReviewMonthlyState extends State<ReviewMonthly> {
  @override
  Widget build(BuildContext context) {
    Year year = widget.reviewBloc.currentYear;

    assert(year != null);
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: ListView.builder(
          shrinkWrap: true,
          controller: widget.scrollController,
          itemCount: year.months.length,
          itemBuilder: (context, index) {
            Month month = year.months[index];
            Review review = month.review ??
                Review(
                    comments: [],
                    title: month.monthName,
                    reviewSpan: ReviewSpan.monthly,
                    categories: [],
                    id: widget.reviewBloc.currentYear.year +
                        addToZero(month.month));
            if (month.review == null) month.review = review;
            if (widget.reviewBloc.reviews.contains(review) == false) {
              widget.reviewBloc.reviews.add(review);
            }
            bool isAggregated = widget.reviewBloc.aggregated.value;

            double largestSubPercentage = 0;
            if (isAggregated)
              for (Month month in year.months) {
                if (month.aggregated.largestSubCatPercentage >=
                    largestSubPercentage)
                  largestSubPercentage =
                      month.aggregated.largestSubCatPercentage;
              }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 12),
                  child: _getReviewListItemTitle(review: review, month: month),
                ),
                InkWell(
                  onTap: () {
                    widget.reviewBloc.currentMonth = month;
                    widget.reviewBloc.reviewSpan.value = ReviewSpan.weekly;
                  },
                  child: ReviewListItem(
                    reviewCategories: review.categories,
                    reviewBloc: widget.reviewBloc,
                    review: review,
                    itemAmount: year.months.length,
                    aggregated: month.aggregated
                      ..largestSubCatPercentage = largestSubPercentage,
                    isAggregated: isAggregated,
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _getReviewListItemTitle({Review review, Month month}) {
    TextStyle style = TextStyle(
        color: colorTextGrey, fontWeight: FontWeight.bold, fontSize: 22);
    if (widget.reviewBloc.aggregated.value == true) {
      return Text(
        review.title,
        style: style,
      );
    } else {
      String lastWeekNumber = "";
      if (month.weeks.length > 1) {
        lastWeekNumber = "-" + month.weeks.last.week;
      }
      return RichText(
          text: TextSpan(children: [
        TextSpan(
          text: "Aggregert ",
          style: style,
        ),
        if (month.weeks.first.review != null)
          TextSpan(
              text: month.weeks.first.review.title + lastWeekNumber,
              style: style)
        else
          TextSpan(text: month.monthName, style: style)
      ]));
    }
  }
}
