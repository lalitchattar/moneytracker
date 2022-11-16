import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../model/account.dart';
import '../../service/account_service.dart';
import '../../util/constants.dart';
import '../../util/utils.dart';
import '../../widget/error_dialog_widget.dart';
import 'detail_account_screen.dart';

class EditAccountScreen extends StatefulWidget {
  final int id;
  const EditAccountScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {

  final AccountService _accountService = AccountService();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
        Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: Text(
            Constants.addAccountScreenAppBarTitle,
            style: TextStyle(
              color: Utils.getColorFromColorCode(Constants.appBarTitleColor),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.deepPurple,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor:
          Utils.getColorFromColorCode(Constants.appBarBackgroundColor),
        ),
        body: FutureBuilder<List<Account>>(
          future: _accountService.getAccountById(widget.id),
          builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
            if(snapshot.hasData) {
              Account? account = snapshot.data?.first;
              return SingleChildScrollView(
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
                                name: Constants.addAccountFormAccountName,
                                initialValue: account?.accountName,
                                decoration: const InputDecoration(
                                  labelText: Constants.addAccountFormAccountNameLabel,
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(
                                        errorText: Constants
                                            .addAccountFormAccountNameRequired)
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account!),
                                child: const SizedBox(
                                  height: 25.0,
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account!),
                                child: FormBuilderTextField(
                                  enabled: _isCreditCard(account!),
                                  initialValue: account.creditLimit.toString(),
                                  name: Constants.addAccountFormCreditLimit,
                                  decoration: const InputDecoration(
                                    labelText:
                                    Constants.creditLimitLabel,
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: FormBuilderValidators.compose(
                                    [
                                      FormBuilderValidators.required(
                                          errorText: Constants
                                              .addAccountFormCreditLimitRequired),
                                      FormBuilderValidators.numeric(
                                          errorText: Constants.enterValidNumber)
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account!),
                                child: const SizedBox(
                                  height: 25.0,
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account!),
                                child: FormBuilderTextField(
                                  initialValue: account.billingDay,
                                  enabled: _isCreditCard(account!),
                                  name: Constants.addAccountFormBillingDay,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText:
                                    Constants.billingDayLabel,
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    await _openDropdownOptionScreen(
                                        Constants.billingDaysOption,
                                        Constants.addAccountFormBillingDay);
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account),
                                child: const SizedBox(
                                  height: 25.0,
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account),
                                child: FormBuilderTextField(
                                  enabled: _isCreditCard(account),
                                  initialValue: account.gracePeriod,
                                  name: Constants.addAccountFormGracePeriod,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText:
                                    Constants.gracePeriodLabel,
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (_getBillingDayValue() == null) {
                                      _formKey.currentState
                                          ?.fields[Constants.addAccountFormBillingDay]
                                          ?.invalidate(Constants.selectBillingDay);
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      return;
                                    }
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    await _openDropdownOptionScreen(
                                        Constants.gracePeriodOption,
                                        Constants.addAccountFormGracePeriod);
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              FormBuilderTextField(
                                name: Constants.addAccountFormAvailableBalance,
                                initialValue: account.availableBalance.toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText:
                                  Constants.availableBalanceLabel,
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.numeric(
                                        errorText: Constants.enterValidNumber)
                                  ],
                                ),
                                valueTransformer: (value) {
                                  return _getAvailableBalanceValue(value, account);
                                },
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              FormBuilderTextField(
                                name: Constants.addAccountFormDescription,
                                initialValue: account.description ?? "",
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
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple),
                                    onPressed: () {
                                      _updateAccount(account);
                                    },
                                    child: const Text(Constants.saveButton),
                                  )),
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
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  bool _isCreditCard(Account account) {
    return account.isCreditCard == 1 ? true : false;
  }

  Future<void> _openDropdownOptionScreen(
      List<String> options, String dropdownName) async {
    await FilterListDelegate.show<String>(
      context: context,
      list: options,
      selectedListData: _getOptionListByDropdownName(dropdownName),
      theme: FilterListDelegateThemeData(),
      // enableOnlySingleSelection: true,
      onItemSearch: (value, query) {
        return value.toLowerCase().contains(query.toLowerCase());
      },
      emptySearchChild: const Center(child: Text(Constants.noOptionFound)),
      searchFieldHint: Constants.searchHere,
      enableOnlySingleSelection: true,
      onApplyButtonClick: (list) {
        setState(
              () {
            if (dropdownName == Constants.addAccountFormBillingDay) {
              _formKey.currentState!.fields[Constants.addAccountFormBillingDay]
                  ?.didChange(list?.first);
            } else {
              _formKey.currentState!.fields[Constants.addAccountFormGracePeriod]
                  ?.didChange(list?.first);
            }
          },
        );
      },
      suggestionBuilder: (context, option, isSelected) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Card(
            elevation: 0,
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: Colors.grey)),
              tileColor: Utils.getColorFromColorCode(
                  Constants.lisListTileColor),
              title: Text(option),
            ),
          ),
        );
      },
    );
  }

  List<String> _getOptionListByDropdownName(String dropdownName) {
    return dropdownName == Constants.addAccountFormBillingDay
        ? Constants.billingDaysOption
        : Constants.gracePeriodOption;
  }

  String? _getBillingDayValue() {
    return _formKey
        .currentState?.fields[Constants.addAccountFormBillingDay]?.value;
  }

  String? _getAvailableBalanceValue(String? value, Account account) {
    if((value == null) && _isCreditCard(account)) {
      return _formKey.currentState!.fields[Constants.addAccountFormCreditLimit]?.value;
    } else if(value == null && !_isCreditCard(account)) {
      return "0.0";
    } else {
      return value;
    }
  }

  void _updateAccount(Account account) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      debugPrint(_formKey.currentState?.value.toString());

      _accountService
          .getAccountByName(
          _formKey.currentState?.fields[Constants.addAccountFormAccountName]?.value)
          .then(
            (accountList) async {
          if (accountList.isNotEmpty && accountList[0].id != widget.id) {
            showDialog(
                context: context,
                builder: (context) => const ErrorDialogWidget(
                    Constants.accountNameAlreadyExists));
          } else {
            await _accountService
                .updateAccount(_formKey.currentState?.value,
                _isCreditCard(account), widget.id)
                .then(
                  (value) => {
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailAccountScreen(widget.id),
                  ),
                )
              },
            );
          }
        },
      );

    }
  }
}
