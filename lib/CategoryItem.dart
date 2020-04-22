import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perspektiv/AddSubCategoryItem.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/main.dart';
import 'package:provider/provider.dart';

import 'model/Category.dart';
import 'model/SubCategory.dart';

class CategoryItem extends StatefulWidget {
  final Category category;

  const CategoryItem({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    if (widget.category.init == true) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => widget.category.init = false);
    }
    _categoriesBloc = Provider.of<CategoriesBloc>(context, listen: false);

    _textController.text = widget.category.name ?? "";

    _focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              TextField(
                controller: _textController,
                focusNode: _focusNode,
                autofocus: widget.category.init == true,
                onChanged: (val) => widget.category.name = val,
                style: TextStyle(
                    color: colorTextGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 22),
                autocorrect: false,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: "Kategori navn",
                  counterStyle: TextStyle(color: colorLeBleu),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    width: 2,
                    color: colorLeBleu,
                  )),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    width: 0.5,
                    color: Colors.grey,
                  )),
                ),
              ),
              Positioned(right: 0, child: _getSuffixIcon())
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 8,
                runSpacing: 16,
                children: widget.category.subCategories.map((subCat) {
                  return InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddSubCategoryItem(
                              subCategory: subCat,
                              isCreate: false,
                              category: widget.category,
                            ))),
                    child: SubCategoryItem(
                        key: Key(subCat.name), subCategory: subCat),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSuffixIcon() {
    if (_focusNode.hasFocus) {
      return IconButton(
        icon: Icon(
          Icons.delete,
          color: colorLove,
        ),
        onPressed: () => _categoriesBloc.removeCategory(widget.category),
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.add,
          color: colorTextGrey,
        ),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddSubCategoryItem(
                  isCreate: true,
                  category: widget.category ?? "",
                  subCategory: SubCategory(
                      name: "",
                      color: appColors[Random().nextInt(appColors.length)]),
                ))),
      );
    }
  }
}

class SubCategoryItem extends StatefulWidget {
  final SubCategory subCategory;

  const SubCategoryItem({
    Key key,
    this.subCategory,
  }) : super(key: key);

  @override
  _SubCategoryItemState createState() => _SubCategoryItemState();
}

class _SubCategoryItemState extends State<SubCategoryItem> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      width: deviceSize.width / 3 - 16,
      height: 45,
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: widget.subCategory.color,
        borderRadius: BorderRadius.all(Radius.elliptical(20, 30)),
      ),
      child: Text(
        widget.subCategory.name,
        style: TextStyle(
          color: isColorDark(widget.subCategory.color),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
