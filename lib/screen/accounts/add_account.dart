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
    "1st",
    "2nd",
    "3rd",
    "4th",
    "5th",
    "6th",
    "7th",
    "8th",
    "9th",
    "10th",
    "11th",
    "12th",
    "13th",
    "14th",
    "15th",
    "16th",
    "17th",
    "18th",
    "19th",
    "20th",
    "21st",
    "22nd",
    "23rd",
    "24th",
    "25th",
    "26th",
    "27th",
    "28th",
    "29th",
    "30th",
    "31st"
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
                  child: FormBuilderDropdown(
                    name: "BILLING_DAY",
                    enabled: _isFieldEnable,
                    decoration: const InputDecoration(
                      labelText: "Billing Day",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: null,
                    items: _billingDays
                        .map((billingDay) => DropdownMenuItem(
                              alignment: AlignmentDirectional.centerStart,
                              value: billingDay,
                              child: Text(billingDay),
                            ))
                        .toList(),
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
                  child: FormBuilderDropdown(
                    name: "GRACE_PERIOD",
                    enabled: _isFieldEnable,
                    decoration: const InputDecoration(
                      labelText: "Grace Period",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: null,
                    onTap: () {
                      _formKey.currentState!.save();
                      if(_formKey.currentState?.fields['BILLING_DAY']?.value == null) {
                          Navigator.pop(context);
                        _formKey.currentState?.fields['BILLING_DAY']?.invalidate("Select Billing Day");
                      }
                    },
                    items: _gracePeriod
                        .map((gracePeriod) => DropdownMenuItem(
                              alignment: AlignmentDirectional.centerStart,
                              value: gracePeriod,
                              child: Text(gracePeriod),
                            ))
                        .toList(),
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
