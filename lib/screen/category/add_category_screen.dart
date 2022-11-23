import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:moneytracker/screen/category/list_category_screen.dart';
import 'package:svg_icon/svg_icon.dart';

import '../../main.dart';
import '../../model/category.dart';
import '../../service/category_service.dart';
import '../../util/category_icon_mapping.dart';
import '../../util/constants.dart';
import '../../util/utils.dart';
import '../../widget/error_dialog_widget.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> with RouteAware {
  final _formKey = GlobalKey<FormBuilderState>();
  final CategoryService _categoryService = CategoryService();
  int _parentCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: const Text(
            Constants.addCategoriesScreenAppBarTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: FormBuilder(
                  key: _formKey,
                  skipDisabled: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: Constants.addCategoryFormCategoryName,
                          decoration: const InputDecoration(
                            labelText: Constants.categoryNameLabel,
                            border: OutlineInputBorder(),
                          ),
                          validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(errorText: Constants.addCategoryFormCategoryNameRequired)],
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        FormBuilderDropdown(
                          name: Constants.addCategoryFormCategoryType,
                          decoration: const InputDecoration(
                            labelText: Constants.addCategoryFormCategoryTypeNameLabel,
                            border: OutlineInputBorder(),
                          ),
                          items: Constants.categoryType.keys
                              .map(
                                (billingDay) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.centerStart,
                                  value: billingDay,
                                  child: Text(billingDay),
                                ),
                              )
                              .toList(),
                          valueTransformer: (value) {
                            return _getCategoryTypeCode(value!);
                          },
                          validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(errorText: Constants.selectCategoryType)],
                          ),
                          onChanged: (value) {
                            _validateCategoryTypeAndResetParentCategory();
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        FormBuilderTextField(
                          name: Constants.addCategoryFormParentCategory,
                          decoration: const InputDecoration(
                            labelText: Constants.addCategoryFormParentCategoryNameLabel,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                          readOnly: true,
                          onTap: () async {
                            validateCategoryTypeOrOpenParentCategoryScreen();
                          },
                          valueTransformer: (value) {
                            return _parentCategoryIndex;
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        FormBuilderTextField(
                          name: Constants.addCategoryFormDescription,
                          decoration: const InputDecoration(
                            labelText: Constants.descriptionLabel,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () {
                              _saveCategory();
                            },
                            child: const Text(Constants.saveButton),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getCategoryTypeCode(String value) {
    if (value == Constants.incomeCategory) {
      return Constants.incomeCategoryCode;
    } else if (value == Constants.expenseCategory) {
      return Constants.expenseCategoryCode;
    } else {
      return Constants.otherCategoryCode;
    }
  }

  void _validateCategoryTypeAndResetParentCategory() {
    _formKey.currentState?.fields[Constants.addCategoryFormCategoryType]?.validate();
    _formKey.currentState?.fields[Constants.addCategoryFormParentCategory]?.didChange(null);
  }

  void validateCategoryTypeOrOpenParentCategoryScreen() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState?.fields[Constants.addCategoryFormCategoryType]?.value == null) {
      _formKey.currentState?.fields[Constants.addCategoryFormCategoryType]?.validate();
    } else {
      await _categoryService
          .getCategoriesByType(Constants.categoryType[_formKey.currentState!.fields[Constants.addCategoryFormCategoryType]?.value]!)
          .then((categories) => openParentCategoryScreen(categories));
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<void> openParentCategoryScreen(List<Category> categories) async {
    await FilterListDelegate.show<Category>(
      context: context,
      list: categories,
      selectedListData: [],
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
        return category.categoryName!.toLowerCase().contains(query.toLowerCase());
      },
      emptySearchChild: const Center(child: Text(Constants.noCategoryFound)),
      searchFieldHint: Constants.searchHere,
      enableOnlySingleSelection: true,
      onApplyButtonClick: (list) {
        setState(
          () {
            _formKey.currentState!.fields[Constants.addCategoryFormParentCategory]?.didChange(list?.first.categoryName);
            _parentCategoryIndex = list!.first.id!;
          },
        );
      },
      suggestionBuilder: (context, category, isSelected) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Card(
            elevation: 0,
            child: ListTile(
              visualDensity: const VisualDensity(vertical: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Colors.grey),
              ),
              tileColor: Utils.getColorFromColorCode(Constants.lisListTileColor),
              leading: CircleAvatar(child: _getSVGIconOrLetter(category)),
              title: Text(category.categoryName, style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: _getChildCountBadge(category),
            ),
          ),
        );
      },
    );
  }

  Widget _getSVGIconOrLetter(Category category) {
    return category.iconId == 0
        ? Text(category.categoryName.substring(0, 1))
        : SvgIcon(
            CategoryIcon.icon[category.iconId]!,
            color: Colors.white,
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

  void _saveCategory() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      _categoryService.getCategoryByName(_formKey.currentState?.fields[Constants.addCategoryFormCategoryName]?.value).then(
        (accountList) {
          if (accountList.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => const ErrorDialogWidget(Constants.categoryWithSameNameAlreadyExists),
            );
          } else {
            _categoryService.createCategory(_formKey.currentState?.value).then(
                  (value) => Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListCategoryScreen(),
                    ),
                  ),
                );
          }
        },
      );
    }
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
