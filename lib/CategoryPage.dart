// ignore: must_be_immutable
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CategoryItem.dart';
import 'bloc/CategoriesBloc.dart';
import 'main.dart';
import 'model/Category.dart';
import 'model/User.dart';

// ignore: must_be_immutable
class CategoryPage extends StatefulWidget with ChangeNotifier {
  final CategoriesBloc categoriesBloc;

  CategoryPage({
    Key key,
    this.categoriesBloc,
  }) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with ChangeNotifier {
  CategoriesBloc _categoriesBloc;
  ScrollController _scrollController = ScrollController();
  List<Provider> providers;

  @override
  void initState() {
    _categoriesBloc = widget.categoriesBloc;
    providers = [
      Provider<CategoriesBloc>.value(value: _categoriesBloc),
    ];
    _categoriesBloc.categoryList.addListener(() => _reBuild());
    _categoriesBloc.onRemoveCategory.addListener(() => _reBuild());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _categoriesBloc.categoryList.removeListener(() => _reBuild());
    _categoriesBloc.onRemoveCategory.removeListener(() => _reBuild());
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading;
    if (_categoriesBloc.categoryList.value == null ||
        _categoriesBloc.categoryList.value.isEmpty) isLoading = true;
    return MultiProvider(
      providers: providers,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(color: isColorDark(colorLeBleu)),
              backgroundColor: colorLeBleu,
              title: Text(
                "Kategorier",
                style: TextStyle(color: isColorDark(colorLeBleu)),
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 30,
                      color: isColorDark(colorLeBleu),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _categoriesBloc.addCategory(
                            Category(init: true, name: "", subCategories: []));
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) => Timer(
                          Duration(milliseconds: 200),
                          () => _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.linear)));
                    }),
              ],
            ),
            backgroundColor: Colors.white,
            //        const Color(0xFFF6F6F6),
            body: isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _categoriesBloc.categoryList.value.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CategoryItem(
                          key: Key(
                              _categoriesBloc.categoryList.value[index].name),
                          category: _categoriesBloc.categoryList.value[index]);
                    })),
      ),
    );
  }

  void _reBuild() {
    if (mounted) setState(() {});
  }
}
