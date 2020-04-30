import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perspektiv/bloc/CategoriesBloc.dart';
import 'package:perspektiv/bloc/ReviewBloc.dart';
import 'package:perspektiv/main.dart';
import 'package:perspektiv/model/Category.dart';
import 'package:perspektiv/model/Review.dart';
import 'package:provider/provider.dart';

class DisplaySettings extends StatefulWidget {
  final ReviewBloc reviewBloc;
  final CategoriesBloc categoriesBloc;

  const DisplaySettings({Key key, this.reviewBloc, this.categoriesBloc})
      : super(key: key);

  @override
  _DisplaySettingsState createState() => _DisplaySettingsState();
}

class _DisplaySettingsState extends State<DisplaySettings> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    widget.reviewBloc.reviewCategory.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ReviewBloc _reviewBloc = widget.reviewBloc;
    bool showInfo = false;

    Size size = MediaQuery.of(context).size;

    return Container(
      height: 300,
      color: colorBackGround,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
            stretch: true,
            titleSpacing: 0,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFE8E8E8),
            title: Text(
              "Hvilken kategori skal vises?",
              style: TextStyle(
                  color: colorTextGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                iconSize: 30,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.only(top: 16, left: 8, right: 8),
                height: 200,
                color: colorBackGround,
                child: GridView.builder(
                    controller: _scrollController,
                    itemCount: widget.categoriesBloc.categoryList.value.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.75),
                    itemBuilder: (context, index) {
                      Category category =
                          widget.categoriesBloc.categoryList.value[index];

                      bool isSelected = widget.reviewBloc.reviewCategory.value
                              .toLowerCase()
                              .trim() ==
                          category.name.toLowerCase().trim();

                      return _CategoryGridItem(
                        key: Key(category.name),
                        category: category,
                        onSelect: () {
                          if (widget.reviewBloc.reviewCategory.value !=
                              category.name)
                            widget.reviewBloc.reviewCategory.value =
                                category.name;
                        },
                        isSelected: isSelected,
                      );
                    }),
              ),
            ]),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Row(
          //       children: <Widget>[
          //         Text(
          //           "Aggregerte vurderinger",
          //           style: TextStyle(
          //               color: colorTextGrey,
          //               fontWeight: FontWeight.w500,
          //               fontSize: 20),
          //         ),
          //         IconButton(
          //             icon: Icon(
          //               Icons.info_outline,
          //               color: colorTextGrey,
          //             ),
          //             onPressed: () {}),
          //       ],
          //     ),
          //     Checkbox(
          //         activeColor: colorLeBleu,
          //         value: _reviewBloc.aggregated.value,
          //         onChanged: (val) {
          //           setState(() {
          //             _reviewBloc.aggregated.value = val;
          //           });
          //         })
          //   ],
          // ),

          // Container(
          //   height: 16,
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Hvilken kategori skal vises?",
                style: TextStyle(
                    color: colorTextGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  iconSize: 30,
                ),
              ),
            ],
          ),
          // Container(
          //   height: 16,
          // ),
          Container(
            height: 160,
            child: GridView.builder(
                itemCount: widget.categoriesBloc.categoryList.value.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.75),
                itemBuilder: (context, index) {
                  Category category =
                      widget.categoriesBloc.categoryList.value[index];

                  bool isSelected = widget.reviewBloc.reviewCategory.value
                          .toLowerCase()
                          .trim() ==
                      category.name.toLowerCase().trim();

                  return _CategoryGridItem(
                    key: Key(category.name),
                    category: category,
                    onSelect: () {
                      if (widget.reviewBloc.reviewCategory.value !=
                          category.name)
                        widget.reviewBloc.reviewCategory.value = category.name;
                    },
                    isSelected: isSelected,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _CategoryGridItem extends StatefulWidget {
  final Category category;
  bool isSelected;
  final VoidCallback onSelect;

  _CategoryGridItem({Key key, this.category, this.isSelected, this.onSelect})
      : super(key: key);

  @override
  __CategoryGridItemState createState() => __CategoryGridItemState();
}

class __CategoryGridItemState extends State<_CategoryGridItem> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return InkWell(
      highlightColor: colorLeBleu.withOpacity(0.5),
      borderRadius: BorderRadius.all(Radius.circular(8)),
//      splashColor: colorDeepSea.withOpacity(0.2),
      onTap: widget.onSelect,
      child: AnimatedContainer(
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        width: deviceSize.width / 3 - 16,
        height: 45,
        duration: Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: widget.isSelected == true ? colorLeBleu : Colors.grey,
          borderRadius: BorderRadius.all(Radius.elliptical(20, 30)),
        ),
        child: Text(
          widget.category.name,
          style: TextStyle(
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
