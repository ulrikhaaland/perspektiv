import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/SubCategory.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../main.dart';
import 'ReviewInput.dart';

class ValueDisplayer extends StatefulWidget {
  final Category category;
  final void Function(SubCategory subCategory) onSubCategoryRemoved;

  const ValueDisplayer({Key key, this.category, this.onSubCategoryRemoved})
      : super(key: key);

  @override
  _ValueDisplayerState createState() => _ValueDisplayerState();
}

class _ValueDisplayerState extends State<ValueDisplayer> {
  ReviewBloc _reviewBloc;

  @override
  void initState() {
    _reviewBloc = Provider.of<ReviewBloc>(context, listen: false);
    _reviewBloc.displayType.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Category category = widget.category;

    final Size size = MediaQuery.of(context).size;

    switch (_reviewBloc.displayType.value) {
      case DisplayType.filler:
        return Column(
          key: Key("subs"),
          children: category.subCategories.map((subCat) {
            return Dismissible(
              onDismissed: (direction) {
                widget.onSubCategoryRemoved(subCat);
              },
              key: Key(subCat.hashCode.toString()),
              child: ReviewSubCategoryItem(
                key: Key(subCat.name),
                subCategory: subCat,
              ),
            );
          }).toList(),
        );
        break;
      case DisplayType.barChart:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 300,
                child: HorizontalBarChart(
                  subCategories: category.subCategories,
                )),
          ],
        );
        break;
      case DisplayType.pieChart:
        return Container(
          height: size.height - 400,
          child: PieChart(
            key: Key("pieChart"),
            subCategories: category.subCategories,
          ),
        );
        break;

      default:
        return Container();
    }
  }
}

class ReviewSubCategoryItem extends StatefulWidget {
  final SubCategory subCategory;
  final Color borderColor;

  const ReviewSubCategoryItem({
    Key key,
    this.subCategory,
    this.borderColor,
  }) : super(key: key);

  @override
  _ReviewSubCategoryItemState createState() => _ReviewSubCategoryItemState();
}

class _ReviewSubCategoryItemState extends State<ReviewSubCategoryItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double itemHeight = size.height / 14;

    SubCategory subCategory = widget.subCategory;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: widget.borderColor ?? colorBackGround, width: 1),
                borderRadius: BorderRadius.all(Radius.elliptical(20, 30)),
              ),
              width: size.width,
              height: itemHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        width: (constraints.maxWidth / 100) *
                                subCategory.percentage ??
                            0,
                        decoration: BoxDecoration(
                          color: subCategory.color,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(20, 30),
                            bottomLeft: Radius.elliptical(20, 30),
                            topRight: subCategory.percentage == 100
                                ? Radius.elliptical(20, 30)
                                : Radius.zero,
                            bottomRight: subCategory.percentage == 100
                                ? Radius.elliptical(20, 30)
                                : Radius.zero,
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          for (var i = 0; i < 9; i++)
                            Container(
                              width: constraints.maxWidth / 10,
                              height: itemHeight,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color:
                                              isDark(color: subCategory.color)
                                                  ? colorBackGround
                                                  : Colors.grey,
                                          width: 1))),
                            ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colorBackGround,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(20, 30),
                            ),
                            color: isDark(
                              color: subCategory.color,
                            )
                                ? Colors.white
                                : Colors.black.withOpacity(0.3),
                          ),
                          child: Text(
                            subCategory.name,
                            textWidthBasis: TextWidthBasis.parent,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: subCategory.color),
                          ),
                        ),
                      )
                    ],
                  );
                },
              )),
        ),
        Column(
          children: subCategory.comments
              .map((comment) => Dismissible(
                    key: Key(comment.hashCode.toString()),
                    onDismissed: (val) {
                      subCategory.comments.remove(comment);
                    },
                    child: ReviewInput(
                      commentList: subCategory.comments,
                      comment: comment,
                    ),
                  ))
              .toList(),
        )
      ],
    );
  }
}

class HorizontalBarChart extends StatefulWidget {
  final List<SubCategory> subCategories;

  HorizontalBarChart({Key key, this.subCategories})
      : assert(subCategories != null),
        super(key: key);

  // The [BarLabelDecorator] has settings to set the text style for all labels
  // for inside the bar and outside the bar. To be able to control each datum's
  // style, set the style accessor functions on the series.
  @override
  _HorizontalBarChartState createState() => _HorizontalBarChartState();
}

class _HorizontalBarChartState extends State<HorizontalBarChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _createSeries(),
      animate: true,
      vertical: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelPosition: charts.BarLabelPosition.inside,
        labelAnchor: charts.BarLabelAnchor.middle,
      ),
      // Hide domain axis.
      domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
    );
  }

  List<charts.Series<SubCategory, String>> _createSeries() {
    return [
      charts.Series<SubCategory, String>(
        fillColorFn: (SubCategory subCategory, _) {
          final color = subCategory.color;
          return charts.ColorUtil.fromDartColor(color);
        },
        id: 'subCategories',
        domainFn: (SubCategory subCategory, _) => subCategory.name,
        measureFn: (SubCategory subCategory, _) => subCategory.percentage / 10,
        measureLowerBoundFn: (SubCategory subCategory, _) => 10,
        measureUpperBoundFn: (SubCategory subCategory, _) => 10,
        data: widget.subCategories,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (SubCategory subCategory, _) => '${subCategory.name}',
        insideLabelStyleAccessorFn: (SubCategory subCategory, _) {
          return charts.TextStyleSpec(
              fontSize: 16,
              color: charts.ColorUtil.fromDartColor(
                  isColorDark(subCategory.color)));
        },
        outsideLabelStyleAccessorFn: (SubCategory subCategory, _) {
          return charts.TextStyleSpec(
              fontSize: 16,
              color: charts.ColorUtil.fromDartColor(colorTextGrey));
        },
      ),
    ];
  }
}

class PieChart extends StatefulWidget {
  final List<SubCategory> subCategories;

  PieChart({Key key, this.subCategories})
      : assert(subCategories != null),
        super(key: key);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  @override
  Widget build(BuildContext context) {
    return charts.PieChart(_createSeries(),
        animate: false,
        // Add an [ArcLabelDecorator] configured to render labels outside of the
        // arc with a leader line.
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //        charts.ArcLabelDecorator(
        //          insideLabelStyleSpec:  charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec:  charts.TextStyleSpec(...)),
        defaultRenderer: charts.ArcRendererConfig(
//            arcWidth: 60,
            arcRendererDecorators: [charts.ArcLabelDecorator()]));
  }

  List<charts.Series<SubCategory, int>> _createSeries() {
    return [
      charts.Series<SubCategory, int>(
        colorFn: (SubCategory subCategory, _) {
          final color = subCategory.color;
          return charts.ColorUtil.fromDartColor(color);
        },

        id: 'subCategories',
        domainFn: (SubCategory subCategory, _) => subCategory.hashCode,
        measureFn: (SubCategory subCategory, _) =>
            subCategory.percentage.toInt(),
        data: widget.subCategories,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (SubCategory subCategory, _) => '${subCategory.name}',
        measureLowerBoundFn: (SubCategory subCategory, _) => 10,
        measureUpperBoundFn: (SubCategory subCategory, _) => 10,
        insideLabelStyleAccessorFn: (SubCategory subCategory, _) {
          return charts.TextStyleSpec(
              fontSize: 16,
              color: charts.ColorUtil.fromDartColor(
                  isColorDark(subCategory.color)));
        },
        outsideLabelStyleAccessorFn: (SubCategory subCategory, _) {
          return charts.TextStyleSpec(
              fontSize: 16,
              color: charts.ColorUtil.fromDartColor(colorTextGrey));
        },
      )
    ];
  }
}
