import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/SubCategory.dart';

import 'model/Unit.dart';

class UnitMeasurement extends StatelessWidget {
  final Unit unit;
  final String currentSubTitle;
  const UnitMeasurement({Key key, this.unit, this.currentSubTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showBottomSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Row(
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
                              text: currentSubTitle,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          TextSpan(text: " er lik")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(20, 30)),
                    color: colorLeBleu.withOpacity(
                        unit.getTitle().toLowerCase() == "ikke valgt"
                            ? 0.5
                            : 1),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Text(
                    unit.getTitle(),
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: colorBackGround,
        // isScrollControlled: true,
        isDismissible: true, // <--- this line
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        context: context,
        builder: (builder) {
          return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: _buildUnitSelector());
        });
  }

  Widget _buildUnitSelector() {
    return DefaultTabController(
      initialIndex: unit.type?.index ?? 0,
      length: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            indicatorPadding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            indicatorColor: colorLeBleu,
            labelColor: colorTextGrey,
            labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            unselectedLabelStyle: TextStyle(color: colorTextGrey),
            tabs: <Widget>[
              Tab(
                text: "Varighet",
              ),
              Tab(
                text: "Gjøremål",
              ),
              Tab(
                text: "Vekt",
              ),
              Tab(
                text: "Egentilpasset",
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
                      _DurationView(
                        unit: unit,
                        currentSubTitle: currentSubTitle,
                      ),
                      Container(),
                      Container(),
                      Container(),
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

const style =
    TextStyle(color: colorTextGrey, fontSize: 20, fontWeight: FontWeight.bold);

Duration duration = Duration(minutes: 1);

class _DurationViewState extends State<_DurationView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Wrap(
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
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      TextSpan(text: " er lik")
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 12,
          ),
          Flexible(
            child: Wrap(
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
          ),
          Container(
            height: 32,
          ),
          Divider(),
          Container(
            alignment: Alignment.topCenter,
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
    );
  }

  void _formatDurations() {
    countHours = duration.inHours;
    countMinutes = duration.inMinutes % 60;
    countSeconds = duration.inSeconds % 60;
  }
}
