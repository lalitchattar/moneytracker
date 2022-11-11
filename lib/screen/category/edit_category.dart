import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:moneytracker/model/category.dart';
import 'package:moneytracker/screen/category/category_details.dart';

import '../../service/category_service.dart';
import '../../widget/error_dialog_widget.dart';
import '../../../main.dart';

class EditCategory extends StatefulWidget {
  final int id;
  const EditCategory(this.id, {Key? key}) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> with RouteAware{
  final _formKey = GlobalKey<FormBuilderState>();

  final CategoryService _categoryService = CategoryService();

  final Map<String, String> _categoryType = {
    "Income Category": "I",
    "Expense Category": "E"
  };

  List<Category>? selectedCategoryList = [];
  int _parentCategoryIndex = 0;
  String? _parentCategory;

  String _getDisplayCategory(String categoryCode) {
    return categoryCode == "I" ? "Income Category" : "Expense Category";
  }

  Future<void> _openFilterDelegate(List<Category> categories) async {
    await FilterListDelegate.show<Category>(
      context: context,
      list: categories,
      selectedListData: selectedCategoryList,
      theme: FilterListDelegateThemeData(
        tileMargin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(width: 1, color: Colors.grey),
          ),
          tileColor: Colors.white,
        ),
      ),
      // enableOnlySingleSelection: true,
      onItemSearch: (category, query) {
        return category.categoryName!
            .toLowerCase()
            .contains(query.toLowerCase());
      },
      tileLabel: (category) => category!.categoryName,
      emptySearchChild: const Center(child: Text('No category found')),
      searchFieldHint: 'Search Here..',
      enableOnlySingleSelection: true,
      onApplyButtonClick: (list) {
        setState(() {
          selectedCategoryList = list;
          _formKey.currentState!.fields['PARENT_CATEGORY']
              ?.didChange(selectedCategoryList?.first.categoryName);
          _parentCategoryIndex = selectedCategoryList!.first.id!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Category"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: FutureBuilder(
          future: _categoryService.getCategoryByIdWithParent(widget.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: SingleChildScrollView(
                    child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: "CATEGORY_NAME",
                        initialValue: snapshot.data?.first.categoryName,
                        decoration: const InputDecoration(
                          labelText: "Category Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: "Enter Category name")
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      FormBuilderDropdown(
                        name: "CATEGORY_TYPE",
                        decoration: const InputDecoration(
                          labelText: "Category Type",
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _getDisplayCategory(
                            snapshot.data?.first.categoryType ?? ""),
                        items: _categoryType.keys
                            .map((billingDay) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.centerStart,
                                  value: billingDay,
                                  child: Text(billingDay),
                                ))
                            .toList(),
                        valueTransformer: (value) {
                          if (value == "Income Category") {
                            return "I";
                          } else if (value == "Expense Category") {
                            return "E";
                          } else {
                            return "O";
                          }
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Select Category Type")
                        ]),
                        onChanged: (value) {
                          _formKey.currentState?.fields['CATEGORY_TYPE']
                              ?.validate();
                          _formKey.currentState?.fields['PARENT_CATEGORY']
                              ?.didChange(null);
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      FormBuilderTextField(
                        name: "PARENT_CATEGORY",
                        decoration: const InputDecoration(
                          labelText: "Parent Category",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        readOnly: true,
                        initialValue: snapshot.data?.first.parentCategoryName,
                        onTap: () async {
                          _formKey.currentState!.save();
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formKey.currentState?.fields['CATEGORY_TYPE']
                                  ?.value ==
                              null) {
                            _formKey.currentState?.fields['CATEGORY_TYPE']
                                ?.validate();
                          } else {
                            await _categoryService
                                .getCategoriesByType(_categoryType[_formKey
                                    .currentState!
                                    .fields['CATEGORY_TYPE']
                                    ?.value]!)
                                .then((categories) =>
                                    _openFilterDelegate(categories));
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                        valueTransformer: (value) {
                          return _parentCategoryIndex;
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      FormBuilderTextField(
                        name: "DESCRIPTION",
                        initialValue: snapshot.data?.first.description,
                        decoration: const InputDecoration(
                          labelText: "Details",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                )),
              );
            } else {
              return const Center(
                child: Text("No Account Details Found"),
              );
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SpeedDial(
          spacing: 5.0,
          icon: Icons.check,
          onPress: () {
            if (_formKey.currentState?.saveAndValidate() ?? false) {
              _categoryService
                  .getCategoryByName(
                      _formKey.currentState?.fields["CATEGORY_NAME"]?.value)
                  .then(
                (categoryList) {
                  if (categoryList.isNotEmpty && widget.id != categoryList[0].id) {
                    showDialog(
                        context: context,
                        builder: (context) => const ErrorDialogWidget(
                            'Category with same name already exists'));
                  } else {
                    _categoryService
                        .updateCategory(_formKey.currentState?.value, widget.id)
                        .then(
                          (value) => Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetails(widget.id),
                            ),
                          ),
                        );
                  }
                },
              );
            }
          },
        ),);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }
}
