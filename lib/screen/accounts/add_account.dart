import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:moneytracker/service/account_service.dart';
import 'package:moneytracker/widget/error_dialog_widget.dart';

import 'list_account.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({Key? key}) : super(key: key);

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isCreditCard = false;
  bool _isFieldEnable = false;
  final _billingDays = [
    "1st of Every Month",
    "2nd of Every Month",
    "3rd of Every Month",
    "4th of Every Month",
    "5th of Every Month",
    "6th of Every Month",
    "7th of Every Month",
    "8th of Every Month",
    "9th of Every Month",
    "10th of Every Month",
    "11th of Every Month",
    "12th of Every Month",
    "13th of Every Month",
    "14th of Every Month",
    "15th of Every Month",
    "16th of Every Month",
    "17th of Every Month",
    "18th of Every Month",
    "19th of Every Month",
    "20th of Every Month",
    "21st of Every Month",
    "22nd of Every Month",
    "23rd of Every Month",
    "24th of Every Month",
    "25th of Every Month",
    "26th of Every Month",
    "27th of Every Month",
    "28th of Every Month",
    "29th of Every Month",
    "30th of Every Month",
    "31st of Every Month"
  ];

  final _gracePeriod = [
    "1 day",
    "2 days",
    "3 days",
    "4 days",
    "5 days",
    "6 days",
    "7 days",
    "8 days",
    "9 days",
    "10 days",
    "11 days",
    "12 days",
    "13 days",
    "14 days",
    "15 days",
    "16 days",
    "17 days",
    "18 days",
    "19 days",
    "20 days",
    "21 days",
    "22 days",
    "23 days",
    "24 days",
    "25 days",
    "26 days",
    "27 days",
    "28 days",
    "29 days",
    "30 days"
  ];

  List<String> _selectedBillingDayList = [];
  List<String> _selectedGracePeriodList = [];

  Future<void> openFilterDelegate(List<String> itemList, String dropdownName) async {
    await FilterListDelegate.show<String>(
      context: context,
      list: itemList,
      selectedListData: dropdownName == "BILLING_DAY" ? _selectedBillingDayList : _selectedGracePeriodList,
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
      onItemSearch: (value, query) {
        return value
            .toLowerCase()
            .contains(query.toLowerCase());
      },
      tileLabel: (value) => value,
      emptySearchChild: const Center(child: Text('No item found')),
      searchFieldHint: 'Search Here..',
      enableOnlySingleSelection: true,
      onApplyButtonClick: (list) {
        setState(() {
          if(dropdownName == "BILLING_DAY") {
            _selectedBillingDayList = list!;
            _formKey.currentState!.fields['BILLING_DAY']
                ?.didChange(_selectedBillingDayList?.first);
          } else {
            _selectedGracePeriodList = list!;
            _formKey.currentState!.fields['GRACE_PERIOD']
                ?.didChange(_selectedGracePeriodList?.first);
          }

        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Account"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListAccount(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            skipDisabled: true,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "ACCOUNT_NAME",
                  decoration: const InputDecoration(
                    labelText: "Account Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                          errorText: "Enter Account name")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 0.0),
                  child: FormBuilderSwitch(
                    title: const Text(
                      'Credit Card?',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    name: 'IS_CREDIT_CARD',
                    initialValue: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    valueTransformer: (value) {
                      return value != null && value ? 1 : 0;
                    },
                    onChanged: (dynamic value) {
                      if (value) {
                        setState(() {
                          _isCreditCard = true;
                          _isFieldEnable = true;
                        });
                      } else {
                        setState(() {
                          _isCreditCard = false;
                          _isFieldEnable = false;
                          _formKey.currentState?.fields["BILLING_DAY"]
                              ?.reset();
                          _formKey.currentState?.fields["GRACE_PERIOD"]
                              ?.reset();
                          _formKey.currentState?.fields["CREDIT_LIMIT"]
                              ?.reset();
                        });
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: _isCreditCard,
                  child: FormBuilderTextField(
                    name: "CREDIT_LIMIT",
                    enabled: _isFieldEnable,
                    decoration: const InputDecoration(
                      labelText: "Credit Limit",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(
                            errorText: "Enter Credit limit"),
                        FormBuilderValidators.numeric(
                            errorText: "Enter valid numbers")
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _isCreditCard,
                  child: const SizedBox(
                    height: 20.0,
                  ),
                ),
                Visibility(
                  visible: _isCreditCard,
                  child:         FormBuilderTextField(
                    enabled: _isFieldEnable,
                    initialValue: null,
                    name: "BILLING_DAY",
                    decoration: const InputDecoration(
                      labelText: "Billing Day",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    readOnly: true,
                    onTap: () async{
                      _formKey.currentState!.save();
                      FocusManager.instance.primaryFocus?.unfocus();
                      await openFilterDelegate(_billingDays, "BILLING_DAY");
                      FocusManager.instance.primaryFocus?.unfocus();
                    },

                  ),
                ),
                Visibility(
                  visible: _isCreditCard,
                  child: const SizedBox(
                    height: 20.0,
                  ),
                ),
                Visibility(
                  visible: _isCreditCard,
                  child: FormBuilderTextField(
                    enabled: _isFieldEnable,
                    initialValue: null,
                    name: "GRACE_PERIOD",
                    decoration: const InputDecoration(
                      labelText: "Grace Period",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    readOnly: true,
                    onTap: () async{
                      _formKey.currentState!.save();
                      FocusManager.instance.primaryFocus?.unfocus();
                      if(_formKey.currentState?.fields['BILLING_DAY']?.value == null) {
                        _formKey.currentState?.fields['BILLING_DAY']?.invalidate("Select Billing Day");
                        FocusManager.instance.primaryFocus?.unfocus();
                        return;
                      }
                      await openFilterDelegate(_gracePeriod, "GRACE_PERIOD");
                      FocusManager.instance.primaryFocus?.unfocus();
                    },

                  ),
                ),
                Visibility(
                  visible: _isCreditCard,
                  child: const SizedBox(
                    height: 20.0,
                  ),
                ),
                FormBuilderTextField(
                    name: "AVAILABLE_BALANCE",
                    decoration: const InputDecoration(
                      labelText: "Available Balance",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    valueTransformer: (value) {
                      return value == null || value.isEmpty ? 0 : value;
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(
                          errorText: "Enter valid numbers"),
                      (value) {
                        if (_isCreditCard &&
                            _formKey.currentState!.fields['CREDIT_LIMIT']
                                    ?.value !=
                                null &&
                            value != null &&
                            value != "") {
                          if (double.parse(_formKey.currentState!
                                  .fields['CREDIT_LIMIT']?.value) <
                              double.parse(value)) {
                            return "Available balance can not be greater than Credit Limit";
                          }
                          return null;
                        }
                      },
                    ])),
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
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            AccountService accountService = AccountService();
            accountService
                .getAccountByName(
                    _formKey.currentState?.fields["ACCOUNT_NAME"]?.value)
                .then((accountList) {
              if (accountList.isNotEmpty) {
                showDialog(
                    context: context,
                    builder: (context) => const ErrorDialogWidget(
                        'Account with same name already exists'));
              } else {
                accountService
                    .createAccount(_formKey.currentState?.value)
                    .then((value) => {
                          accountService
                              .updateOutstandingBalance(value)
                              .then((value) => {
                                    Navigator.pop(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ListAccount(),
                                      ),
                                    )
                                  })
                        });
              }
            });
          }
        },
      ),
    );
  }
}
