import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:perspektiv/model/Day.dart';
import 'package:perspektiv/model/Decade.dart';
import 'package:perspektiv/model/Month.dart';
import 'package:perspektiv/model/Week.dart';
import 'package:perspektiv/model/Year.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ReviewSpan { daily, weekly, monthly, yearly }

class ReviewBloc {
  ValueNotifier<Decade> decade = ValueNotifier(null);

  DateTime initDate;

  Year currentYear;

  Month currentMonth;

  Week currentWeek;

  Day currentDay;

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
    decade.value = _getDecade();
    return initDate;
  }

  Future<void> getUserData() async {
    var prefs = await SharedPreferences.getInstance();

    var decadeData = prefs.getString("decade");

    if (decade.value != null) {
      decade.value = Decade.fromJson(jsonDecode(decadeData));
    } else {
      decade.value = _getDecade();
    }
  }

  Decade _getDecade() {
    return Decade(decade: 1, years: _getYears());
  }

  List<Year> _getYears() {
    List<Year> years = [];

    for (int i = 0; i <= (initDate.year - DateTime.now().year); i++) {
      years.add(Year(
        year: initDate.year + i,
        months: _getMonths(initDate.year + i),
      ));
    }

    return years;
  }

  List<Month> _getMonths(int year) {
    List<Month> months = [];

    for (int i = 0; i <= (initDate.month - DateTime.now().month); i++) {
      months.add(Month(
        month: initDate.month + i,
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
        Week week = Week(week: weekNumber, days: []);

        /// Indicates wether a week is filled up with days. The current week will
        /// not hold 7 days if current date is not a sunday
        bool hasACompleteWeek = false;
        while (!hasACompleteWeek) {
          /// Add day to week
          week.days.add(Day(day: firstDayOfMonth));

          /// Increment firstDayOfMonth if it's before tomorrows date
          if (!firstDayOfMonth.add(Duration(days: 1)).isAfter(DateTime.now())) {
            firstDayOfMonth = firstDayOfMonth.add(Duration(days: 1));
          }

          /// If firstDayOfMonth is a sunday then the week is filled up
          /// then we return to a new loop
          if (firstDayOfMonth.weekday == 7) {
            hasACompleteWeek = true;
            week.days.add(Day(day: firstDayOfMonth));
            weeks.add(week);
            weekNumber++;
            if (firstDayOfMonth.isAfter(initDate))
              firstDayOfMonth = firstDayOfMonth.add(Duration(days: 1));
          } else if (firstDayOfMonth
              .add(Duration(days: 1))
              .isAfter(DateTime.now())) {
//            week.days.add(Day(day: firstDayOfMonth));
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
    return weeksTilInitCount;
  }
}
