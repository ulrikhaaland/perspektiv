import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:provider/provider.dart';

class DisplaySettings extends StatefulWidget {
  final ReviewBloc reviewBloc;

  const DisplaySettings({Key key, this.reviewBloc}) : super(key: key);

  @override
  _DisplaySettingsState createState() => _DisplaySettingsState();
}

class _DisplaySettingsState extends State<DisplaySettings> {
  @override
  Widget build(BuildContext context) {
    ReviewBloc _reviewBloc = widget.reviewBloc;
    bool showInfo = false;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Aggregerte vurderinger",
                    style: TextStyle(
                        color: colorTextGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: colorTextGrey,
                      ),
                      onPressed: () {}),
                ],
              ),
              Checkbox(
                  activeColor: colorLeBleu,
                  value: _reviewBloc.aggregated.value,
                  onChanged: (val) {
                    setState(() {
                      _reviewBloc.aggregated.value = val;
                    });
                  })
            ],
          ),
        ],
      ),
    );
  }
}
