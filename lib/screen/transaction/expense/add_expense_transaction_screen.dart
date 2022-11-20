import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:svg_icon/svg_icon.dart';
import '../../../main.dart';
import '../../../model/account.dart';
import '../../../model/category.dart';
import '../../../service/account_service.dart';
import '../../../service/category_service.dart';

import '../../../service/transaction_service.dart';
import '../../../util/all_screen_icon.dart';
import '../../../util/category_icon_mapping.dart';
import '../../../util/constants.dart';
import '../../../util/utils.dart';
import '../transaction_details.dart';
import '../transaction_details_screen.dart';

class AddExpenseTransactionScreen extends StatefulWidget {
  const AddExpenseTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseTransactionScreen> createState() =>
      _AddExpenseTransactionScreenState();
}

class _AddExpenseTransactionScreenState
    extends State<AddExpenseTransactionScreen> with RouteAware {
  final CategoryService _categoryService = CategoryService();
  final TransactionService _transactionService = TransactionService();
  final AccountService _accountService = AccountService();

  final _formKey = GlobalKey<FormBuilderState>();
  late int? _accountId;
  late int? _categoryId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: const Text(
            Constants.addExpenseScreenAppBarTitle,
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
                        FormBuilderDateTimePicker(
                          name: Constants.addTransactionScreenTransactionDate,
                          initialEntryMode: DatePickerEntryMode.calendar,
                          initialValue: DateTime.now(),
                          inputType: InputType.both,
                          decoration: const InputDecoration(
                            labelText: Constants
                                .addTransactionScreenTransactionDateLabel,
                            border: OutlineInputBorder(),
                          ),
                          initialTime: const TimeOfDay(hour: 8, minute: 0),
                          valueTransformer: (value) {
                            final DateFormat formatter =
                                DateFormat(Constants.dateTimeFormat);
                            return formatter.format(value!);
                          },
                          // locale: const Locale.fromSubtags(languageCode: 'fr'),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        FormBuilderTextField(
                          initialValue: null,
                          name: Constants.addTransactionScreenFromAccount,
                          decoration: const InputDecoration(
                            labelText:
                                Constants.fromAccountLabel,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: Constants.selectAccount),
                            ],
                          ),
                          readOnly: true,
                          onTap: () async {
                            await _openAccountSelectionDialog();
                          },
                          valueTransformer: (value) {
                            return _accountId;
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        FormBuilderTextField(
                          initialValue: null,
                          name: Constants.addTransactionScreenCategory,
                          decoration: const InputDecoration(
                            labelText:
                                Constants.addTransactionScreenCategoryLabel,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          readOnly: true,
                          onTap: () async {
                            await _openCategorySelectionDialog();
                          },
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: Constants.selectCategory),
                            ],
                          ),
                          valueTransformer: (value) {
                            return _categoryId;
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        FormBuilderTextField(
                          name: Constants.finalAmount,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _formKey
                                .currentState
                                ?.fields[
                                    Constants.finalAmount]
                                ?.validate();
                          },
                          decoration: const InputDecoration(
                            labelText:
                                Constants.addTransactionScreenFinalAmountLabel,
                            border: OutlineInputBorder(),
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                  errorText: Constants.enterFinalAmount),
                              FormBuilderValidators.numeric(
                                  errorText: Constants.enterValidAmount)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        FormBuilderTextField(
                          name: Constants.addTransactionScreenDescription,
                          decoration: const InputDecoration(
                            labelText:
                                Constants.addTransactionScreenDetailsLabel,
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
                              _saveIncomeTransaction();
                            },
                            child: const Text(Constants.addButton),
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

  Future<void> _openAccountSelectionDialog() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await _accountService
        .getAllAccounts(false)
        .then((accounts) => openAccountSelectionScreen(accounts));
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> openAccountSelectionScreen(List<Account> accounts) async {
    await FilterListDelegate.show<Account>(
      context: context,
      list: accounts,
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
      onItemSearch: (account, query) {
        return account.accountName!.toLowerCase().contains(query.toLowerCase());
      },
      emptySearchChild: const Center(child: Text(Constants.noCategoryFound)),
      searchFieldHint: Constants.searchHere,
      enableOnlySingleSelection: true,
      onApplyButtonClick: (list) {
        setState(
          () {
            _formKey
                .currentState!.fields[Constants.addTransactionScreenFromAccount]
                ?.didChange(list?.first.accountName);
            _accountId = list!.first.id!;
          },
        );
      },
      suggestionBuilder: (context, account, isSelected) {
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
              tileColor:
                  Utils.getColorFromColorCode(Constants.lisListTileColor),
              leading: CircleAvatar(
                  child: _getAccountTypeIcon(account)
              ),
              title: Text(account.accountName,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: Text(
                Utils.formatNumber(account.availableBalance),
                style: TextStyle(
                    color: _getBalanceColor(account),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }

  MaterialColor _getBalanceColor(Account account) {
    return account.availableBalance > 0 ? Colors.green : Colors.red;
  }

  SvgIcon _getAccountTypeIcon(Account account) {
    return account.isCreditCard == 1
        ? const SvgIcon(AllScreenIcon.creditCard, color: Colors.white,)
        : const SvgIcon(AllScreenIcon.bank, color: Colors.white,);
  }

  Future<void> _openCategorySelectionDialog() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await _categoryService
        .getCategoriesByType(Constants.expenseCategoryCode)
        .then((categories) => openCategorySelectionScreen(categories));
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> openCategorySelectionScreen(List<Category> categories) async {
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
        return category.categoryName!
            .toLowerCase()
            .contains(query.toLowerCase());
      },
      emptySearchChild: const Center(child: Text(Constants.noCategoryFound)),
      searchFieldHint: Constants.searchHere,
      enableOnlySingleSelection: true,
      onApplyButtonClick: (list) {
        setState(
          () {
            _formKey
                .currentState!.fields[Constants.addTransactionScreenCategory]
                ?.didChange(list?.first.categoryName);
            _categoryId = list!.first.id!;
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
              tileColor:
                  Utils.getColorFromColorCode(Constants.lisListTileColor),
              leading: CircleAvatar(
                child: _getSVGIconOrLetter(category)
              ),
              title: Text(category.categoryName,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: _getChildCountBadge(category),
            ),
          ),
        );
      },
    );
  }


  Widget _getSVGIconOrLetter(Category category) {
    return category.iconId == 0 ? Text(category.categoryName.substring(0, 1)) : SvgIcon(CategoryIcon.icon[category.iconId]!, color: Colors.white,);
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

  void _saveIncomeTransaction() async {
    final navigator = Navigator.of(context);
    int? transactionId;
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      await _transactionService
          .createTransaction(
              _formKey.currentState?.value, Constants.expenseCategoryCode)
          .then(
        (value) async {
          transactionId = value;
          await _accountService.getAccountById(_accountId!).then(
            (accountList) async {
              Account account = accountList.first;
              account.availableBalance = account.availableBalance -
                  double.parse(_formKey
                      .currentState
                      ?.fields[Constants.finalAmount]
                      ?.value);
              account.debitedAmount = account.debitedAmount +
                  double.parse(_formKey
                      .currentState
                      ?.fields[Constants.finalAmount]
                      ?.value);
              account.outTransaction = account.outTransaction + 1;
              account.outstandingBalance = account.outstandingBalance! +
                  double.parse(_formKey
                      .currentState
                      ?.fields[Constants.finalAmount]
                      ?.value);
              await _accountService
                  .updateAccountForOutTransaction(account.toMap(),
                      account.isCreditCard == 1 ? true : false, account.id!)
                  .then(
                (value) async {
                  await _categoryService.getCategoryById(_categoryId!).then(
                    (categoryList) async {
                      Category category = categoryList.first;
                      category.debitedAmount = category.debitedAmount +
                          double.parse(_formKey
                              .currentState
                              ?.fields[
                                  Constants.finalAmount]
                              ?.value);
                      category.outTransaction = category.outTransaction + 1;
                      await _categoryService.updateCategoryForOutTransaction(
                          category.toMap(), category.id!);
                    },
                  );
                },
              );
            },
          );
        },
      );
      navigator.pop();
      navigator.push(MaterialPageRoute(
          builder: (context) => TransactionDetailScreen(transactionId!)));
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
