import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/Decade.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/Year.dart';
import 'package:perspektiv/review/ReviewListItem.dart';

class ReviewYearly extends StatefulWidget {
  final ReviewBloc reviewBloc;
  final ScrollController scrollController;

  const ReviewYearly({Key key, this.reviewBloc, this.scrollController})
      : super(key: key);

  @override
  _ReviewYearlyState createState() => _ReviewYearlyState();
}

class _ReviewYearlyState extends State<ReviewYearly> {
  @override
  Widget build(BuildContext context) {
    Decade decade = widget.reviewBloc.decade;
    assert(decade != null);
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: ListView.builder(
          shrinkWrap: true,
          controller: widget.scrollController,
          itemCount: decade.years.length,
          itemBuilder: (context, index) {
            Year year = decade.years[index];
            year.aggregate();
            Review review = year.review ??
                Review(
                    comments: [],
                    reviewSpan: ReviewSpan.yearly,
                    categories: [],
                    id: year.year,
                    title: year.year.toString());
            if (year.review == null) year.review = review;
            if (widget.reviewBloc.reviews.contains(review) == false) {
              widget.reviewBloc.reviews.add(review);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 12),
                  child: _getReviewListItemTitle(review: review, year: year),
                ),
                InkWell(
                  onTap: () {
                    widget.reviewBloc.currentYear = year;
                    widget.reviewBloc.reviewSpan.value = ReviewSpan.monthly;
                  },
                  child: ReviewListItem(
                    reviewBloc: widget.reviewBloc,
                    reviewCategories:
                        //TODO: fix needed when user has not yet entered into underlying values so
                        widget.reviewBloc.aggregated.value == false
                            ? review.categories
                            : year.aggregatedCategories,
                    review: review,
                    itemAmount: decade.years.length,
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _getReviewListItemTitle({Review review, Year year}) {
    TextStyle style = TextStyle(
        color: colorTextGrey, fontWeight: FontWeight.bold, fontSize: 22);
    if (widget.reviewBloc.aggregated.value == false) {
      return Text(
        review.title,
        style: style,
      );
    } else {
      String lastMonthNumber = "";
      if (year.months.length > 1) {
        lastMonthNumber = "-" + year.months.last.month;
      }
      return RichText(
          text: TextSpan(children: [
        TextSpan(
          text: "Aggregert ",
          style: style,
        ),
        TextSpan(
            text: year.months.first.review.title + lastMonthNumber,
            style: style)
      ]));
    }
  }
}
