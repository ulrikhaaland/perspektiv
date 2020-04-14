import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Decade.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';
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
    Decade decade = widget.reviewBloc.decade.value;
    assert(decade != null);
    return ListView.builder(
        shrinkWrap: true,
        controller: widget.scrollController,
        itemCount: decade.years.length,
        itemBuilder: (context, index) {
          Year year = decade.years[index];
          Review review = year.review ?? Review(categories: []);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24, top: 12),
                child: Text(
                  year.year.toString(),
                  style: TextStyle(
                      color: colorTextGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
              InkWell(
                onTap: () {
                  widget.reviewBloc.currentYear = year;
                  widget.reviewBloc.reviewSpan.value = ReviewSpan.monthly;
                },
                child: Container(
                  height: 100,
                  child: ReviewListItem(
                    review: review,
                    itemAmount: decade.years.length,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
