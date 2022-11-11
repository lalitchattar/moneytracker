import 'package:flutter/material.dart';
import 'package:moneytracker/model/category.dart';
import 'package:moneytracker/screen/category/edit_category.dart';
import 'package:moneytracker/screen/category/list_category.dart';

import '../../service/category_service.dart';
import '../../widget/error_dialog_widget.dart';

class CategoryDetails extends StatefulWidget {
  final int id;
  const CategoryDetails(this.id, {Key? key}) : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Details"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListCategory(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditCategory(widget.id)))
                    .then((value) => setState(() {}));
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                _showDeleteConfirmationDialog(widget.id);
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Category>>(
          future: _categoryService.getCategoryById(widget.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(width: 1, color: Colors.grey),
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    snapshot.data!.first.categoryName
                                        .substring(0, 1),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(snapshot.data!.first.categoryName),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(width: 1, color: Colors.grey),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5.0,
                            ),
                            ListTile(
                              leading: const Text("Details"),
                              trailing: Text(
                                  snapshot.data!.first.description ?? "---"),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            const Divider(thickness: 2),
                            ListTile(
                              leading: const Text("Category Type"),
                              trailing: Text(
                                  snapshot.data!.first.categoryType == "I"
                                      ? "Income"
                                      : "Expense"),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            const Divider(thickness: 2),
                            ListTile(
                              leading: const Text("In Transaction"),
                              trailing: Text(snapshot.data!.first.inTransaction
                                  .toString()),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            const Divider(thickness: 2),
                            ListTile(
                              leading: const Text("Out Transaction"),
                              trailing: Text(snapshot.data!.first.outTransaction
                                  .toString()),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible:
                            snapshot.data?.first.childCount == 0 ? false : true,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side:
                                const BorderSide(width: 1, color: Colors.grey),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15),
                            child: Wrap(
                              runSpacing: -5,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      "Sub Category",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                FutureBuilder<List<Category>>(
                                  future:
                                      _categoryService.getCategoryByParentId(
                                          snapshot.data?.first.id ?? 0),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<Category>> snapshot1) {
                                    if (snapshot1.hasData) {
                                      return ListView.builder(
                                          itemCount: snapshot1.data!.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Card(
                                              child: ListTile(
                                                dense: true,
                                                visualDensity:
                                                    const VisualDensity(
                                                        vertical: -1),
                                                leading: const Icon(
                                                    Icons.account_box),
                                                title: Text(snapshot1
                                                    .data![index].categoryName),
                                              ),
                                            );
                                          });
                                    } else {
                                      return const Center(
                                        child: Text("No Account Details Found"),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text("No Account Details Found"),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Are you sure to delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('NO', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'YES',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _categoryService
                    .isHavingChildCategory(widget.id)
                    .then((value) {
                          if (!value){
                            _categoryService.deleteCategory(id);
                            Navigator.pop(context);
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListCategory(),
                              ),
                            );
                          }
                          else
                            {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) => const ErrorDialogWidget(
                                      'Category can not be deleted as it is having child category'));
                            }
                        });
              },
            ),
          ],
        );
      },
    );
  }
}
