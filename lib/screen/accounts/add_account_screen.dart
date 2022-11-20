import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:moneytracker/screen/accounts/list_account_screen.dart';
import 'package:moneytracker/widget/error_dialog_widget.dart';

import '../../main.dart';
import '../../service/account_service.dart';
import '../../util/constants.dart';
import '../../util/utils.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({Key? key}) : super(key: key);

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> with RouteAware {
  final AccountService _accountService = AccountService();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isCreditCard = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: const Text(
            Constants.addAccountScreenAppBarTitle,
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
                          name: Constants.addAccountFormAccountName,
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
                        FormBuilderSwitch(
                          name: Constants.addAccountFormCreditCardName,
                          title: const Text(
                            Constants.addAccountFormCreditCardLabel,
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.black54),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isCreditCard = value!;
                              _resetCreditCardFields();
                            });
                          },
                          valueTransformer: (value) {
                            return value != null && value ? 1 : 0;
                          },
                        ),
                        Visibility(
                          visible: _isCreditCard,
                          child: FormBuilderTextField(
                            enabled: _isCreditCard,
                            name: Constants.addAccountFormCreditLimit,
                            decoration: const InputDecoration(
                              labelText: Constants.creditLimitLabel,
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
                          visible: _isCreditCard,
                          child: const SizedBox(
                            height: 25.0,
                          ),
                        ),
                        Visibility(
                          visible: _isCreditCard,
                          child: FormBuilderTextField(
                            enabled: _isCreditCard,
                            name: Constants.addAccountFormBillingDay,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: Constants.billingDayLabel,
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
                          visible: _isCreditCard,
                          child: const SizedBox(
                            height: 25.0,
                          ),
                        ),
                        Visibility(
                          visible: _isCreditCard,
                          child: FormBuilderTextField(
                            enabled: _isCreditCard,
                            name: Constants.addAccountFormGracePeriod,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: Constants.gracePeriodLabel,
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
                        Visibility(
                          visible: _isCreditCard,
                          child: const SizedBox(
                            height: 25.0,
                          ),
                        ),
                        FormBuilderTextField(
                          name: Constants.addAccountFormAvailableBalance,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: Constants.availableBalanceLabel,
                            border: OutlineInputBorder(),
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.numeric(
                                  errorText: Constants.enterValidNumber)
                            ],
                          ),
                          valueTransformer: (value) {
                            return _getAvailableBalanceValue(value);
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        FormBuilderTextField(
                          name: Constants.addAccountFormDescription,
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
                              _saveAccount();
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

  Future<void> _openDropdownOptionScreen(
      List<String> options, String dropdownName) async {
    await FilterListDelegate.show<String>(
      context: context,
      list: options,
      selectedListData: [],
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
              tileColor:
                  Utils.getColorFromColorCode(Constants.lisListTileColor),
              title: Text(option),
            ),
          ),
        );
      },
    );
  }

  void _saveAccount() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      debugPrint(_formKey.currentState?.value.toString());
      _accountService
          .getAccountByName(_formKey
              .currentState?.fields[Constants.addAccountFormAccountName]?.value)
          .then(
        (accountList) {
          if (accountList.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) =>
                  const ErrorDialogWidget(Constants.accountNameAlreadyExists),
            );
          } else {
            _accountService.createAccount(_formKey.currentState?.value).then(
                  (value) => {
                    _accountService.updateOutstandingBalance(value).then(
                          (value) => {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListAccountScreen(),
                              ),
                            )
                          },
                        )
                  },
                );
          }
        },
      );
    }
  }

  String? _getBillingDayValue() {
    return _formKey
        .currentState?.fields[Constants.addAccountFormBillingDay]?.value;
  }

  void _resetCreditCardFields() {
    _formKey.currentState?.fields[Constants.addAccountFormBillingDay]?.reset();
    _formKey.currentState?.fields[Constants.addAccountFormGracePeriod]?.reset();
    _formKey.currentState?.fields[Constants.addAccountFormCreditLimit]?.reset();
  }

  String? _getAvailableBalanceValue(String? value) {
    if ((value == null) && _isCreditCard) {
      return _formKey
          .currentState!.fields[Constants.addAccountFormCreditLimit]?.value;
    } else if (value == null && !_isCreditCard) {
      return "0.0";
    } else {
      return value;
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
