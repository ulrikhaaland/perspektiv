import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/model/Decade.dart';
import 'package:perspektiv/model/Month.dart';
import 'package:perspektiv/model/User.dart';
import 'package:perspektiv/model/Week.dart';
import 'package:perspektiv/model/Year.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc {
  ValueNotifier<User> user = ValueNotifier(User(categories: mock));


}
