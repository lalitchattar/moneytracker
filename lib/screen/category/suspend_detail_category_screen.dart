import 'package:flutter/material.dart';

import '../../model/category.dart';
import '../../service/category_service.dart';
import '../../util/constants.dart';
import '../../util/utils.dart';
import '../../widget/error_dialog_widget.dart';
import 'edit_category_screen.dart';
import 'list_category_screen.dart';


class SuspendDetailCategoryScreen extends StatefulWidget {
  final int id;
  const SuspendDetailCategoryScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<SuspendDetailCategoryScreen> createState() => _SuspendDetailCategoryScreenState();
}

class _SuspendDetailCategoryScreenState extends State<SuspendDetailCategoryScreen> {

  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
        Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: const Text(
            Constants.detailCategoryScreenAppBarTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          actions: [
            _buildPopupMenuButton()
          ],
        ),
        body: FutureBuilder<List<Category>>(
          future: _categoryService.getCategoryById(widget.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.hasData) {
              Category? category = snapshot.data?.first;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 0,
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: CircleAvatar(
                                  radius: 40.0,
                                  child: Text(category!.categoryName
                                      .substring(0, 1)
                                      .toUpperCase()),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                category!.categoryName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        Constants.descriptionLabel,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                      Text(
                                        category.description ??
                                            Constants.noInfo,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        Constants.inTransaction,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                      Text(
                                        category.inTransaction.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        Constants.outTransaction,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                      Text(
                                        category.outTransaction.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        Constants.creditedAmount,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                      Text(
                                        Utils.formatNumber(
                                            category.creditedAmount),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        Constants.debitedAmount,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                      Text(
                                        Utils.formatNumber(
                                            category.debitedAmount),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: category.childCount > 0,
                        child: Card(
                          elevation: 0,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Center(
                                child: Text(
                                  "Sub Categories",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FutureBuilder<List<Category>>(
                                future: _categoryService
                                    .getCategoryByParentId(category.id ?? 0),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Category>> snapshot1) {
                                  if (snapshot1.hasData) {
                                    return ListView.builder(
                                      itemCount: snapshot1.data!.length,
                                      shrinkWrap: true,
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Category subCategory =
                                        snapshot1.data![index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Card(
                                            color: Utils.getColorFromColorCode(
                                                Constants
                                                    .detailCategorySubCategoryListTileColor),
                                            child: ListTile(
                                              dense: true,
                                              visualDensity:
                                              const VisualDensity(
                                                  vertical: -1),
                                              title: Text(
                                                subCategory.categoryName,
                                                style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return const Center(
                                      child: Text(
                                          Constants.noSubCategoryDetailFound),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(Constants.noAccountFound),
              );
            }
          },
        ),
      ),
    );
  }

  PopupMenuButton _buildPopupMenuButton() {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.deepPurple,
      ),
      itemBuilder: (context) {
        return const [
          PopupMenuItem<int>(
            value: 0,
            child: Text(Constants.resume),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Text(Constants.delete),
          ),
        ];
      },
      onSelected: (value) async {
        if (value == 0) {
          await _showSuspendConfirmationDialog(widget.id);
        } else if (value == 1) {
          await _showDeleteConfirmationDialog(widget.id);
        }
      },
    );
  }

  Future<void> _showSuspendConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            Constants.confirm,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(Constants.areYouSureToResumeAgain),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
              const Text(Constants.no, style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                Constants.yes,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _categoryService.toggleSuspendCategory(id, 0);
                Navigator.pop(context);
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListCategoryScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            Constants.confirm,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(Constants.areYouSureToDelete),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
              const Text(Constants.no, style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                Constants.yes,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _categoryService.isHavingChildCategory(widget.id).then(
                      (value) {
                    if (!value) {
                      _categoryService.deleteCategory(id);
                      Navigator.pop(context);
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListCategoryScreen(),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => const ErrorDialogWidget(Constants
                            .categoryCanNotBeDeletedAsHavingChildCategory),
                      );
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
