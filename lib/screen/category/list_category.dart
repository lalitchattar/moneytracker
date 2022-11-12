import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moneytracker/screen/category/add_category.dart';
import 'package:moneytracker/screen/category/category_details.dart';
import 'package:moneytracker/service/category_service.dart';

import '../../model/category.dart';
import '../more.dart';


class ListCategory extends StatefulWidget {
  const ListCategory({Key? key}) : super(key: key);

  @override
  State<ListCategory> createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory> {

  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const More(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder<List<Category>>(
          future: _categoryService.getAllCategories(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryDetails(
                                    snapshot.data![index].id ?? 0))).then((value) => setState((){}));
                      },
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(snapshot.data![index].categoryName.substring(0, 1).toUpperCase()),
                          ),
                          trailing: snapshot.data![index].childCount != 0 ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Chip(label: Text(snapshot.data![index].childCount.toString())),
                          ) : const Text(""),
                          title: Text(snapshot.data![index].categoryName, style: const TextStyle(fontWeight: FontWeight.w500),),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        spacing: 5.0,
        icon: Icons.add,
        onPress: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCategory()))
              .then((value) => setState(() {}));
        },
      ),
    );
  }
}
