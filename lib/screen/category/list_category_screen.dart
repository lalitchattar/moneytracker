import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moneytracker/model/category.dart';
import 'package:moneytracker/screen/category/add_category_screen.dart';
import 'package:moneytracker/screen/category/detail_category_screen.dart';
import 'package:moneytracker/screen/category/suspend_detail_category_screen.dart';
import 'package:svg_icon/svg_icon.dart';
import '../../service/category_service.dart';

import '../../util/category_icon_mapping.dart';
import '../../util/constants.dart';
import '../../util/utils.dart';

class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ListCategoryScreen> createState() => _ListCategoryScreenState();
}

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: const Text(
            Constants.listCategoriesScreenAppBarTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Category>>(
          future: _categoryService.getAllCategories(true),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100), //
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Category category = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 0,
                        child: GestureDetector(
                          child: ListTile(
                            visualDensity: const VisualDensity(vertical: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            tileColor: _getTileColor(category),
                            leading: CircleAvatar(
                              radius: 20.0,
                              child: _getSVGIconOrLetter(category),
                            ),
                            title: Text(
                              category.categoryName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: _getChildCountBadge(category),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    _getDetailScreenBasedOnSuspendStatus(
                                        category),
                              ),
                            ).then(
                              (value) => setState(
                                () {},
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: SpeedDial(
          spacing: 5.0,
          icon: Icons.add,
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCategoryScreen(),
              ),
            ).then((value) => setState(() {}));
          },
        ),
      ),
    );
  }

  Widget _getChildCountBadge(Category category) {
    return category.childCount != 0
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              label: Text(
                category.childCount.toString(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          )
        : const Text(Constants.blank);
  }

  _getTileColor(Category category) {
    return category.isSuspended == 1
        ? Utils.getColorFromColorCode(Constants.listSuspendedListTileColor)
        : Utils.getColorFromColorCode(Constants.lisListTileColor);
  }

  Widget _getDetailScreenBasedOnSuspendStatus(Category account) {
    return account.isSuspended == 1
        ? SuspendDetailCategoryScreen(account.id)
        : DetailCategoryScreen(account.id);
  }

  Widget _getSVGIconOrLetter(Category category) {
    return category.iconId == 0 ? Text(category.categoryName.substring(0, 1)) : SvgIcon(CategoryIcon.icon[category.iconId]!, color: Colors.white,);
  }
}
