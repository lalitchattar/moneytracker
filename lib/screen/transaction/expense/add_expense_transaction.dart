import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:moneytracker/model/category.dart';
import 'package:moneytracker/service/account_service.dart';

import '../../../model/account.dart';
import '../../../service/category_service.dart';

class AddExpenseTransaction extends StatefulWidget {
  const AddExpenseTransaction({Key? key}) : super(key: key);

  @override
  State<AddExpenseTransaction> createState() => _AddExpenseTransactionState();
}

class _AddExpenseTransactionState extends State<AddExpenseTransaction> {

  final _formKey = GlobalKey<FormBuilderState>();
  final CategoryService _categoryService = CategoryService();
  final AccountService _accountService = AccountService();
  List<Account>? selectedAccountList = [];
  List<Category>? selectedCategoryList = [];

  Future<void> openFilterDelegateForAccount(BuildContext context, List<Account> accounts) async {
    await FilterListDelegate.show<Account>(
        context: context,
        list: accounts,
        enableOnlySingleSelection: true,
        onItemSearch: (account, query) {
          return account.accountName.toLowerCase().contains(query.toLowerCase());
        },
        onApplyButtonClick: (list) {
          setState(() {
            selectedAccountList = list;
            _formKey.currentState!.fields['TO_ACCOUNT']
                ?.didChange(selectedAccountList?.first.accountName);
            _formKey.currentState?.fields['TO_ACCOUNT']?.validate();
          });
        },
        suggestionBuilder: (context, account, isSelected) {
          return Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: Text(account.accountName),
              trailing: Text(account.availableBalance.toString()),
            ),
          );
        }
    );
  }

  Future<void> openFilterDelegateForCategory(BuildContext context, List<Category> categories) async {
    await FilterListDelegate.show<Category>(
        context: context,
        list: categories,
        enableOnlySingleSelection: true,
        onItemSearch: (category, query) {
          return category.categoryName.toLowerCase().contains(query.toLowerCase());
        },
        onApplyButtonClick: (list) {
          setState(() {
            selectedCategoryList = list;
            _formKey.currentState!.fields['CATEGORY']
                ?.didChange(selectedCategoryList?.first.categoryName);
            _formKey.currentState?.fields['CATEGORY']?.validate();
          });
        },
        suggestionBuilder: (context, category, isSelected) {
          return Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: Text(category.categoryName),
              trailing: Text(category.childCount == 0 ? "" : category.childCount.toString()),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Add Expense Transaction"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            skipDisabled: true,
            child: Column(
              children: [
                FormBuilderDateTimePicker(
                  name: 'TRANSACTION_DATE',
                  initialEntryMode: DatePickerEntryMode.calendar,
                  initialValue: DateTime.now(),
                  inputType: InputType.both,
                  decoration: const InputDecoration(
                    labelText: 'Date & Time',
                    border: OutlineInputBorder(),
                  ),
                  initialTime: const TimeOfDay(hour: 8, minute: 0),
                  // locale: const Locale.fromSubtags(languageCode: 'fr'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                  initialValue: null,
                  name: "FROM_ACCOUNT",
                  decoration: const InputDecoration(
                    labelText: "From Account",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                          errorText: "Select account"),
                    ],
                  ),
                  readOnly: true,
                  onTap: () async{
                    await _accountService.getAllAccounts().then((accounts) => openFilterDelegateForAccount(context, accounts));
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                    initialValue: null,
                    name: "CATEGORY",
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    readOnly: true,
                    onTap: () async{
                      await _categoryService.getCategoriesByType("E").then((categories) => openFilterDelegateForCategory(context, categories));
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(
                            errorText: "Select category"),
                      ],
                    )
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                  name: "FINAL_AMOUNT",
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _formKey.currentState?.fields["FINAL_AMOUNT"]?.validate();
                  },
                  decoration: const InputDecoration(
                    labelText: "Final Amount",
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                          errorText: "Enter final amount"),
                      FormBuilderValidators.numeric(
                          errorText: "Enter valid amount")
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                  name: "DESCRIPTION",
                  decoration: const InputDecoration(
                    labelText: "Details",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SpeedDial(
        spacing: 5.0,
        icon: Icons.check,
        onPress: () {
          _formKey.currentState?.saveAndValidate();
        },
      ),
    );
  }
}
