import 'package:flutter/material.dart';
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
    return Container(
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: RichText(
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
                  TextSpan(text: " er lik ")
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => null,
            child: Container(
                color: colorLeBleu.withOpacity(
                    unit.getTitle().toLowerCase() == "ikke valgt" ? 0.5 : 1),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
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
    );
  }
}
