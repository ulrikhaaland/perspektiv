import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/CustomUnit.dart';
import 'package:perspektiv/model/SubCategory.dart';
import 'package:perspektiv/review/ValueDisplayer.dart';

import 'CategoryItem.dart';
import 'model/Unit.dart';

const style =
    TextStyle(color: colorTextGrey, fontSize: 20, fontWeight: FontWeight.bold);

class UnitMeasurement extends StatefulWidget {
  final List<Unit> units;
  final SubCategory subCategory;

  const UnitMeasurement({Key key, this.units, this.subCategory})
      : assert(units != null),
        super(key: key);

  @override
  _UnitMeasurementState createState() => _UnitMeasurementState();
}

class _UnitMeasurementState extends State<UnitMeasurement> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: RichText(
                    overflow: TextOverflow.clip,
                    text: TextSpan(
                      style: TextStyle(
                        color: colorTextGrey,
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(text: "1 verdi av "),
                        TextSpan(
                            text: widget.subCategory.name,
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        TextSpan(text: " er lik")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
          ),
          Expanded(
              child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              for (Unit unit in widget.units)
                Dismissible(
                    key: Key(unit.hashCode.toString()),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_) {
                      widget.units.remove(unit);
                    },
                    child: _buildUnitButton(context, unit: unit, isAdd: false)),
              _buildUnitButton(context,
                  unit: Unit(
                    type: UnitType.custom,
                  ),
                  isAdd: true),
            ],
          ))
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Unit unit) {
    showModalBottomSheet(
        backgroundColor: colorBackGround,
        isDismissible: true,
        isScrollControlled: true,
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Container(
              height: 500,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16),
                  child: _buildUnitSelector(unit)),
            ),
          );
        });
  }

  Widget _buildUnitSelector(Unit unit) {
    return DefaultTabController(
      initialIndex: unit.type?.index ?? 0,
      length: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            indicatorPadding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            indicatorColor: colorLeBleu,
            labelPadding: EdgeInsets.zero,
            labelColor: colorTextGrey,
            labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            unselectedLabelStyle: TextStyle(color: colorTextGrey),
            tabs: <Widget>[
              Tab(
                text: "Egendefinert",
              ),
              Tab(
                text: "Gjøremål",
              ),
              Tab(
                text: "Varighet",
              ),
              Tab(
                text: "Vekt",
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Divider(),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      _CustomView(
                        unit: unit,
                        currentSubTitle: widget.subCategory.name,
                      ),
                      _BinaryView(unit: unit, subCategory: widget.subCategory),
                      _DurationView(
                        unit: unit,
                        currentSubTitle: widget.subCategory.name,
                      ),
                      _WeightView(
                        unit: unit,
                        currentSubTitle: widget.subCategory.name,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUnitButton(BuildContext context, {Unit unit, bool isAdd}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          _showBottomSheet(context, unit);
          if (isAdd)
            Timer(
              Duration(milliseconds: 200),
              () => setState(() {
                widget.units.add(unit);
              }),
            );
        },
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(20, 30)),
              color: isAdd == true ? colorCalmness : colorLeBleu,
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: isAdd == true
                ? Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  )
                : Container(
                    alignment: Alignment.center,
                    height: 30,
                    child: Text(
                      unit.getTitle(),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
      ),
    );
  }
}

class _BinaryView extends StatefulWidget {
  final Unit unit;
  final SubCategory subCategory;

  const _BinaryView({Key key, this.unit, this.subCategory}) : super(key: key);

  @override
  __BinaryViewState createState() => __BinaryViewState();
}

class __BinaryViewState extends State<_BinaryView> {
  SubCategory subCategory;

  bool init = true;

  @override
  void initState() {
    subCategory = SubCategory(
        name: widget.subCategory.name ?? "Udefinert",
        percentage: 0,
        color: widget.subCategory.color,
        comments: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (init)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Timer(Duration(milliseconds: 150), () {
          setState(() => subCategory.percentage = 100);
          init = false;
        });
      });
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Gjøremål",
              style: style,
            ),
            Container(
              height: 12,
            ),
            Text(
              "Et gjøremål beskriver noe som enten har blitt utført eller ikke. Det vil si at det kun ka ha 1 verdi. Det er binært.",
              style: TextStyle(fontSize: 16),
            ),
            Container(
              height: 16,
            ),
            Divider(),
            Container(
              height: 16,
            ),
            ReviewSubCategoryItem(
              type: ReviewSubType.binary,
              subCategory: subCategory,
              borderColor: colorTextGrey,
            ),
            Container(
              height: 32,
            ),
            InkWell(
              onTap: () {
                if (subCategory.percentage > 0)
                  subCategory.percentage = 0;
                else
                  subCategory.percentage = 100;
                setState(() {});
              },
              child: SubCategoryItem(
                subCategory: subCategory,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationView extends StatefulWidget {
  final Unit unit;
  final String currentSubTitle;

  _DurationView({Key key, this.unit, this.currentSubTitle}) : super(key: key);

  @override
  _DurationViewState createState() => _DurationViewState();
}

bool minute = true;
bool hour = false;
bool seconds = false;

String durationName = "Minutt";

int countMinutes = 0;
int countHours = 0;
int countSeconds = 0;

Duration duration = Duration(hours: 0);

class _DurationViewState extends State<_DurationView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Wrap(
              children: <Widget>[
                RichText(
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                    style: TextStyle(
                      color: colorTextGrey,
                      fontSize: 20,
                    ),
                    children: [
                      TextSpan(text: "1 verdi av "),
                      TextSpan(
                          text: widget.currentSubTitle,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " er lik")
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 12,
            ),
            Wrap(
              spacing: 8,
              children: <Widget>[
                if (countHours > 0)
                  RichText(
                    overflow: TextOverflow.clip,
                    text: TextSpan(style: style, children: [
                      TextSpan(text: countHours.toString()),
                      if (countHours > 1)
                        TextSpan(text: " timer")
                      else
                        TextSpan(text: " time")
                    ]),
                  )
                else
                  Text(
                    " ",
                    style: style,
                  ),
                if (countMinutes > 0)
                  RichText(
                    text: TextSpan(
                        style: style.copyWith(fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(text: countMinutes.toString()),
                          if (countMinutes > 1)
                            TextSpan(text: " Minutter")
                          else
                            TextSpan(text: " minutt")
                        ]),
                  ),
                if (countSeconds > 0)
                  RichText(
                    text: TextSpan(
                        style: style.copyWith(fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(text: countSeconds.toString()),
                          if (countSeconds > 1)
                            TextSpan(text: " sekunder")
                          else
                            TextSpan(text: " sekund")
                        ]),
                  ),
              ],
            ),
            Container(
              height: 16,
            ),
            Divider(),
            Container(
              height: 300,
              child: CupertinoTimerPicker(
                backgroundColor: colorBackGround,
                mode: CupertinoTimerPickerMode.hms,
                minuteInterval: 1,
                secondInterval: 1,
                initialTimerDuration: duration,
                onTimerDurationChanged: (Duration changedtimer) {
                  setState(() {
                    duration = changedtimer;
                    _formatDurations();
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _formatDurations() {
    countHours = duration.inHours;
    countMinutes = duration.inMinutes % 60;
    countSeconds = duration.inSeconds % 60;
  }
}

class _WeightView extends StatefulWidget {
  final String currentSubTitle;
  final Unit unit;

  _WeightView({Key key, this.currentSubTitle, this.unit}) : super(key: key);

  @override
  __WeightViewState createState() => __WeightViewState();
}

class __WeightViewState extends State<_WeightView> {
  TextEditingController _textController = TextEditingController();

  FocusNode _focusNode = FocusNode();

  ScrollController _scrollController = ScrollController();

  bool kilo = true;
  bool grams = false;

  @override
  void initState() {
    _focusNode.addListener(() => _scroll());
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(() => _scroll());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.only(top: 32),
          child: Column(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  RichText(
                    overflow: TextOverflow.clip,
                    text: TextSpan(
                      style: TextStyle(
                        color: colorTextGrey,
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(text: "1 verdi av "),
                        TextSpan(
                            text: widget.currentSubTitle,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " er lik")
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 12,
              ),
              if (_textController.text.isNotEmpty)
                Text(
                  _textController.text + " " + (kilo ? "Kilo " : "Gram"),
                  style: style,
                )
              else
                Text(
                  " ",
                  style: style,
                ),
              Container(
                height: 16,
              ),
              Divider(),
              Container(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: kilo,
                        activeColor: colorGreen,
                        onChanged: (_) {
                          if (kilo == false) {
                            setState(() {
                              kilo = true;
                              grams = false;
                            });
                          }
                        },
                      ),
                      Text(
                        "Kilo",
                        style: style,
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: grams,
                        activeColor: colorGreen,
                        onChanged: (_) {
                          if (grams == false) {
                            setState(() {
                              grams = true;
                              kilo = false;
                            });
                          }
                        },
                      ),
                      Text(
                        "Gram",
                        style: style,
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 32.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextField(
                  focusNode: _focusNode,
                  controller: _textController,
                  onChanged: (val) => setState(() {}),
                  style: TextStyle(
                    color: colorTextGrey,
                    fontFamily: "Apercu",
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: colorTextGrey,
                    )),
                    counterStyle: TextStyle(color: colorLeBleu),
                    labelText: "Antall",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scroll() {
    if (_focusNode.hasFocus)
      Timer(
          Duration(milliseconds: 150),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 250),
              curve: Curves.linear));
  }
}

class _CustomView extends StatefulWidget {
  final Unit unit;
  final String currentSubTitle;

  _CustomView({Key key, this.unit, this.currentSubTitle}) : super(key: key);

  @override
  __CustomViewState createState() => __CustomViewState();
}

class __CustomViewState extends State<_CustomView> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerValue = TextEditingController();

  FocusNode _focusNodeType = FocusNode();
  FocusNode _focusNodeValue = FocusNode();

  ScrollController _scrollController = ScrollController();

  CustomUnit customUnit;

  @override
  void initState() {
    _focusNodeType.addListener(() => _scroll());
    _focusNodeValue.addListener(() => _scroll());
    if (widget.unit.customUnit == null) {
      widget.unit.customUnit = CustomUnit(unitValue: "", unitName: "");
    }
    customUnit = widget.unit.customUnit;

    _controllerName.text = customUnit.unitName;
    _controllerValue.text = customUnit.unitValue;
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeType.removeListener(() => _scroll());
    _focusNodeValue.removeListener(() => _scroll());

    super.dispose();
  }

  void _scroll() {
    if (_focusNodeType.hasFocus || _focusNodeValue.hasFocus)
      Timer(
          Duration(milliseconds: 150),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 250),
              curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.only(top: 32),
          child: Column(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  RichText(
                    overflow: TextOverflow.clip,
                    text: TextSpan(
                      style: TextStyle(
                        color: colorTextGrey,
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(text: "1 verdi av "),
                        TextSpan(
                            text: widget.currentSubTitle,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " er lik")
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_controllerValue.text.isNotEmpty)
                    Text(
                      _controllerValue.text + " ",
                      style: style,
                    )
                  else
                    Text(
                      " ",
                      style: style,
                    ),
                  if (_controllerName.text.isNotEmpty)
                    Text(
                      _controllerName.text + " ",
                      style: style,
                    )
                  else
                    Text(
                      " ",
                      style: style,
                    ),
                ],
              ),
              Container(
                height: 16,
              ),
              Divider(),
              Container(
                height: 32,
              ),
              TextField(
                focusNode: _focusNodeType,
                controller: _controllerName,
                onChanged: (val) => setState(() {
                  customUnit.unitName = val;
                }),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Apercu",
                ),
                autocorrect: false,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: colorTextGrey,
                  )),
                  counterStyle: TextStyle(color: colorLeBleu),
                  labelText: "Måleenhet",
                  hintText: "For eksempel: Meter",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              Container(
                height: 32,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextField(
                  focusNode: _focusNodeValue,
                  controller: _controllerValue,
                  onChanged: (val) => setState(() {
                    customUnit.unitValue = val;
                  }),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Apercu",
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: colorTextGrey,
                    )),
                    counterStyle: TextStyle(color: colorLeBleu),
                    labelText: "Verdi",
                    hintText: "For eksempel: 100",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
