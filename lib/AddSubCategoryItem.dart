import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perspektiv/ColorPicker.dart';
import 'package:perspektiv/model/Unit.dart';
import 'UnitMeasurement.dart';
import 'main.dart';
import 'model/Category.dart';
import 'model/SubCategory.dart';

class AddSubCategoryItem extends StatefulWidget {
  final SubCategory subCategory;
  final Category category;
  final bool isCreate;

  const AddSubCategoryItem(
      {Key key, this.subCategory, this.category, this.isCreate})
      : super(key: key);

  @override
  _AddSubCategoryItemState createState() => _AddSubCategoryItemState();
}

class _AddSubCategoryItemState extends State<AddSubCategoryItem> {
  final TextEditingController _textController = TextEditingController();

  Color tempColor;

  @override
  void initState() {
    tempColor = widget.subCategory.color;
    _textController.text = widget.subCategory.name ?? "";
    if (widget.subCategory.units == null) widget.subCategory.units = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    Color color = tempColor;
    print(color.value);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: isColorDark(color)),
          backgroundColor: color,
          centerTitle: true,
          actions: <Widget>[
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                widget.subCategory
                  ..name = _textController.text
                  ..color = tempColor;
                if (widget.isCreate) {
                  widget.category.subCategories.add(widget.subCategory);
                }
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "Lagre",
                    style: TextStyle(
                        color: isColorDark(color),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.isCreate == true) ...[
                Text(
                  "Ny i ",
                  style: TextStyle(color: isColorDark(color)),
                ),
                Text(
                  widget.category.name,
                  style: TextStyle(
                      color: isColorDark(
                    color,
                  )),
                  overflow: TextOverflow.ellipsis,
                ),
              ] else ...[
                Text(
                  "Rediger",
                  style: TextStyle(
                      color: isColorDark(
                    color,
                  )),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: widget.isCreate
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (!widget.isCreate)
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.transparent,
                          ),
                          onPressed: null),
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        width: deviceSize.width / 3 - 16,
                        height: 45,
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(20, 30)),
                        ),
                        child: Text(
                          _textController.text,
                          style: TextStyle(
                            color: isColorDark(color),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (!widget.isCreate)
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: colorLove,
                            size: 40,
                          ),
                          onPressed: () {
                            widget.category.subCategories
                                .remove(widget.subCategory);
                            Navigator.pop(context);
                          })
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextField(
                    controller: _textController,
                    onChanged: (val) => setState(() {}),
//                  autofocus: true,
                    style: TextStyle(
                      color: colorTextGrey,
                      fontFamily: "Apercu",
                    ),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: colorTextGrey,
                      )),
                      counterStyle: TextStyle(color: colorLeBleu),
                      labelText: "Navn",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                Container(
                  height: 16,
                ),
                Divider(),
                UnitMeasurement(
                  subCategory: widget.subCategory,
                  units: widget.subCategory.units,
                ),
                Divider(),
                _buildColorListTile(),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorListTile() {
    return InkWell(
      onTap: () => _showBottomSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
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
                          TextSpan(text: "Jeg forbinder "),
                          TextSpan(
                              text: _textController.text != ""
                                  ? _textController.text
                                  : "Udefinert",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          TextSpan(text: " med fargen")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: tempColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: colorBackGround,
        isScrollControlled: true,
        isDismissible: true,
        // <--- this line
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: ColorPicker(
                color: tempColor,
                onChanged: (val) => setState(() => tempColor = val),
              ),
            ),
          );
        });
  }
}
