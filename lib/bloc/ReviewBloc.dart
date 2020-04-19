import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:perspektiv/helper.dart';
import 'package:perspektiv/model/Day.dart';
import 'package:perspektiv/model/Decade.dart';
import 'package:perspektiv/model/Month.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:perspektiv/model/Week.dart';
import 'package:perspektiv/model/Year.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ReviewSpan { yearly, monthly, weekly, daily }

class ReviewBloc {
  Decade decade;

  ChangeNotifier doneLoading = ChangeNotifier();

  DateTime initDate;

  Year currentYear;

  Month currentMonth;

  Week currentWeek;

  Day currentDay;

  List<Review> reviews = [];

  ValueNotifier<String> reviewCategory = ValueNotifier(null);

  ValueNotifier<ReviewSpan> reviewSpan = ValueNotifier(ReviewSpan.yearly);

  ValueListenable<ReviewSpan> get reviewSpanListenable => reviewSpan;

  ReviewBloc() {
    userInit();
  }

  Future<DateTime> userInit() async {
    var prefs = await SharedPreferences.getInstance();

    var prefsInitDate = prefs.getString("initDate");

    if (prefsInitDate != null) initDate = DateTime.parse(prefsInitDate);

    if (initDate == null) {
      initDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().subtract(Duration(days: 5)).day);
      await prefs.setString("initDate", initDate.toIso8601String());
    }
    decade = _getDecade();
    return initDate;
  }

  Future<void> getUserData() async {
    var prefs = await SharedPreferences.getInstance();

    var decadeData = prefs.getString("decade");

    if (decade != null) {
      decade = Decade.fromJson(jsonDecode(decadeData));
    } else {
      decade = _getDecade();
    }
  }

  Decade _getDecade() {
    return Decade(decade: "1", years: _getYears());
  }

  List<Year> _getYears() {
    List<Year> years = [];

    for (int i = 0; i <= (initDate.year - DateTime.now().year); i++) {
      years.add(Year(
        year: (initDate.year + i).toString(),
        months: _getMonths(initDate.year + i),
      ));
    }

    return years;
  }

  List<Month> _getMonths(int year) {
    List<Month> months = [];

    for (int i = 0; i <= (initDate.month - DateTime.now().month); i++) {
      months.add(Month(
        month: addToZero((initDate.month + i).toString()),
        weeks: _getWeeks(month: initDate.month + i, year: year),
      ));
    }

    return months;
  }

  List<Week> _getWeeks({int month, int year}) {
    List<Week> weeks = [];

    /// While loop decider
    bool isBeforeTomorrow = true;

    /// Weeknumber for first day in month
    int weekNumber = _getWeekNumber(month, year);

    /// Variable which is used to increment each day that goes into the month's weeks
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    /// While firstDayOfMonth is before the day after current date.
    while (isBeforeTomorrow) {
      /// If firstDayOfMonth is before the date the user initialized the application (initDate): Set firstDayOfMonth as
      /// the first day in the week of initDate.
      bool isBeforeInitDate = firstDayOfMonth.isBefore(initDate);

      while (isBeforeInitDate) {
        /// For each sunday increment weekNumber.
        if (firstDayOfMonth.weekday == 7) weekNumber++;

        /// this will increment firstDayOfMonth until it is the same day as initDate
        if (firstDayOfMonth.isBefore(initDate)) {
          firstDayOfMonth = firstDayOfMonth.add(Duration(days: 1));
        } else {
          /// Set [firstDayOfMonth] to monday in week of initDay
          while (firstDayOfMonth.weekday != 1) {
            firstDayOfMonth = firstDayOfMonth.subtract(Duration(days: 1));
          }

          /// Getting here indicates that the first day in the week of initDate has been found,
          /// which is a monday.
          isBeforeInitDate = false;
        }
      }

      /// While the continuously incremented firstDayOfMonth is in bounds of the relevant month
      while (month == firstDayOfMonth.month && isBeforeTomorrow) {
        /// Init the week which holds the days
        Week week = Week(week: addToZero(weekNumber.toString()), days: []);

        /// Indicates wether a week is filled up with days. The current week will
        /// not hold 7 days if current date is not a sunday
        bool hasACompleteWeek = false;
        while (!hasACompleteWeek) {
          /// Add day to week
          week.days.add(Day(
              dayDate: firstDayOfMonth,
              day: addToZero(firstDayOfMonth.day.toString())));

          /// Increment firstDayOfMonth if it's before tomorrows date
          if (!firstDayOfMonth.add(Duration(days: 1)).isAfter(DateTime.now())) {
            firstDayOfMonth = firstDayOfMonth.add(Duration(days: 1));
          }

          /// If firstDayOfMonth is a sunday then the week is filled up
          /// then we return to a new loop
          print(DateTime.now());
          if (firstDayOfMonth.weekday == 7) {
            hasACompleteWeek = true;
            week.days.add(Day(
                dayDate: firstDayOfMonth,
                day: addToZero(firstDayOfMonth.day.toString())));
            weeks.add(week);
            weekNumber++;
            if (firstDayOfMonth.isAfter(initDate)) {
              firstDayOfMonth = firstDayOfMonth.add(Duration(days: 1));
              if (firstDayOfMonth
                  .add(Duration(days: 1))
                  .isAfter(DateTime.now())) {
                isBeforeTomorrow = false;
                break;
              }
            }
          } else if (firstDayOfMonth
              .add(Duration(days: 1))
              .isAfter(DateTime.now())) {
            week.days.add(Day(
                dayDate: firstDayOfMonth,
                day: addToZero(firstDayOfMonth.day.toString())));
            weeks.add(week);
            isBeforeTomorrow = false;
            break;
          }
        }
      }
    }
    return weeks;
  }

  int _getWeekNumber(int month, int year) {
    DateTime startDate = DateTime(
      year,
      month,
      1,
    );
    int weeksTilInitCount = 0;
    DateTime incremented = DateTime(year, 1, 1);

    while (incremented.isBefore(startDate)) {
      weeksTilInitCount++;
//      print(weeksTilInitCount);
      bool isSunday = false;
      while (!isSunday) {
        if (incremented.weekday == 7) isSunday = true;
        incremented = incremented.add(Duration(days: 1));
      }
    }
    getReviews();
    return weeksTilInitCount;
  }

  pairWithReview() {
    List<Review> yearReviewList =
        reviews.where((rew) => rew.id.length == 4).toList();

    List<Review> monthReviewList =
        reviews.where((rew) => rew.id.length == 6).toList();

    List<Review> weekReviewList =
        reviews.where((rew) => rew.id.length == 8).toList();

    List<Review> dayReviewList =
        reviews.where((rew) => rew.id.length == 10).toList();

    /// Pair year
    for (Review yearReview in yearReviewList) {
      Year year = decade.years
          .firstWhere((y) => y.year == yearReview.id, orElse: () => null);
      if (year != null) {
        year.review = yearReview;

        /// Pair month
        for (Review monthReview in monthReviewList) {
          print(monthReview.id.substring(4, 6));
          Month month = year.months.firstWhere(
              (m) => m.month == monthReview.id.substring(4, 6),
              orElse: () => null);
          if (month != null) {
            month.review = monthReview;

            /// Pair week
            for (Review weekReview in weekReviewList) {
              Week week = month.weeks.firstWhere(
                  (w) => w.week == weekReview.id.substring(6, 8),
                  orElse: () => null);
              if (week != null) {
                week.review = weekReview;

                /// Pair day
                for (Review dayReview in dayReviewList) {
                  Day day = week.days.firstWhere(
                      (d) => d.day == dayReview.id.substring(8, 10),
                      orElse: () => null);
                  if (day != null) {
                    day.review = dayReview;
                  }
                }
              }
            }
          }
        }
      }
    }
    doneLoading.notifyListeners();
  }

  Future<void> getReviews() async {
    var prefs = await SharedPreferences.getInstance();

    var reviewData = prefs.getString("reviews");
    if (reviewData != null) {
      var json = jsonDecode(reviewData);

      reviews = (json['reviews'] as List)
          ?.map((e) => e == null ? null : Review.fromJson(e as Map))
          ?.toList();
    }
    pairWithReview();
  }

  Future<void> saveReviews() async {
//    pairWithReview();
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        "reviews",
        jsonEncode(<String, dynamic>{
          'reviews': reviews,
        }));
  }
}
