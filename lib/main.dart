import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perspektiv/CategoryItem.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:provider/provider.dart';

import 'review/Reviewables.dart';
import 'bloc/CategoriesBloc.dart';
import 'model/User.dart';

void main() => runApp(MyApp());

const colorLove = Color(0xFFe67399);
const colorCalmness = Color(0xFFa1c4fd);
const colorGreen = Color(0xFF78dea6);
const colorImperial = Color(0xFF7a95f1);
const colorLightBlue = Color(0xFFbfdbe9);
const colorLeBleu = Color(0xFF7a95f1);
const colorTextGrey = Color(0xFF3f5261);
const colorCard = Color(0xFFffdea6);
const colorHappiness = Color(0xFFFFE067);
const colorDeepSea = Color(0xFF59778F);
const colorSorrow = Color(0xFF191A24);
const colorLightPink = Color(0xFFF1B2A3);
const colorFear = Color(0xFF7C70A0);
const colorAnger = Color(0xFF963232);

const List<Color> appColors = [
  colorLeBleu,
  colorGreen,
  colorCalmness,
  colorLightBlue,
  colorLightPink,
  colorCard,
  colorLove,
  colorHappiness,
  colorFear,
];

Color isColorDark(Color color) {
  double darkness =
      1 - (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  if (darkness < 0.3) {
    return colorTextGrey; // It's a light color
  } else {
    return Colors.white; // It's a dark color
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(

          color: colorLeBleu,
          iconTheme: IconThemeData(color: colorTextGrey),
          textTheme: TextTheme(
            title: TextStyle(fontSize: 26),
          ),
        ),
        iconTheme: IconThemeData(color: colorTextGrey),
        fontFamily: 'Apercu',
        dividerTheme:
            DividerThemeData(indent: 0, endIndent: 0, thickness: 1, space: 1),
        primarySwatch: Colors.blue,
      ),
      home: Reviewables(),
    );
  }
}


