import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Month.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/SubCategory.dart';
import 'package:perspektiv/model/Week.dart';

import '../main.dart';
import 'ReviewListItem.dart';

class ReviewWeekly extends StatefulWidget {
  final ReviewBloc reviewBloc;
  final ScrollController scrollController;

  const ReviewWeekly({Key key, this.reviewBloc, this.scrollController})
      : super(key: key);

  @override
  _ReviewWeeklyState createState() => _ReviewWeeklyState();
}

class _ReviewWeeklyState extends State<ReviewWeekly> {
  @override
  Widget build(BuildContext context) {
    Month month = widget.reviewBloc.currentMonth;
    assert(month != null);
    return ListView.builder(
        shrinkWrap: true,
        controller: widget.scrollController,
        itemCount: month.weeks.length,
        itemBuilder: (context, index) {
          Week week = month.weeks[index];
          Review review = week.review ?? Review(categories: []);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24, top: 12),
                child: Text(
                  "Uke " + week.week.toString(),
                  style: TextStyle(
                      color: colorTextGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
              InkWell(
                onTap: () {
                  widget.reviewBloc.currentWeek = week;
                  widget.reviewBloc.reviewSpan.value = ReviewSpan.daily;
                },
                child: Container(
                  height: 100,
                  child: ReviewListItem(
                    category: review.categories.firstWhere(
                        (cat) =>
                            cat.name.toLowerCase() ==
                            widget.reviewBloc.reviewCategory.value
                                .toLowerCase(),
                        orElse: () => Category(subCategories: [
                              SubCategory(
                                  name: "Ikke definert",
                                  color: Colors.grey,
                                  percentage: 100),
                            ])),
                    itemAmount: month.weeks.length,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
