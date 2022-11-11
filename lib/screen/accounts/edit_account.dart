import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:moneytracker/screen/accounts/account_details.dart';
import 'package:moneytracker/service/account_service.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moneytracker/widget/error_dialog_widget.dart';
import 'package:moneytracker/screen/accounts/list_account.dart';
import 'package:moneytracker/util/utils.dart';
import 'package:moneytracker/model/account.dart';

class EditAccount extends StatefulWidget {
  final int id;
  const EditAccount(this.id, {Key? key}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final AccountService _accountService = AccountService();
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isCreditCard = false;
  bool _isFieldEnable = false;
  String? _billingDay;

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
        title: const Text("Edit Account"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder<List<Account>>(
        future: _accountService.getAccountById(widget.id),
        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
          if (snapshot.hasData) {
            _isCreditCard =
                snapshot.data!.first.isCreditCard == 1 ? true : false;
            _isFieldEnable = _isCreditCard;
            _billingDay = snapshot.data!.first.billingDay;
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FormBuilder(
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
                            initialValue: snapshot.data!.first.accountName,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(
                                    errorText: "Enter Account name")
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
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
                              initialValue: Utils.formatNumber(
                                      snapshot.data!.first.creditLimit)
                                  .toString(),
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
                              initialValue: snapshot.data!.first.billingDay,
                              onChanged: (value) {
                                _billingDay = value;
                              },
                              items: _billingDays
                                  .map((billingDay) => DropdownMenuItem(
                                        alignment:
                                            AlignmentDirectional.centerStart,
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
                              initialValue: snapshot.data!.first.gracePeriod,
                              onTap: () {
                                if (_billingDay == null) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text('Select Billing day'),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height -
                                                150,
                                        right: 10,
                                        left: 10),
                                  ));
                                }
                              },
                              items: _gracePeriod
                                  .map((gracePeriod) => DropdownMenuItem(
                                        alignment:
                                            AlignmentDirectional.centerStart,
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
                            initialValue: Utils.formatNumber(
                                    snapshot.data!.first.availableBalance)
                                .toString(),
                            valueTransformer: (value) {
                              return value == null || value.isEmpty ? 0 : value;
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.numeric(
                                  errorText: "Enter valid numbers"),
                              (value) {
                                if (_isCreditCard &&
                                    _formKey.currentState!
                                            .fields['CREDIT_LIMIT']?.value !=
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
                            ]),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Visibility(
                            visible: _isCreditCard,
                            child: FormBuilderTextField(
                              enabled: _isFieldEnable,
                              name: "OUTSTANDING_BALANCE",
                              initialValue: Utils.formatNumber(
                                      snapshot.data!.first.outstandingBalance)
                                  .toString(),
                              decoration: const InputDecoration(
                                labelText: "Outstanding Balance",
                                border: OutlineInputBorder(),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.numeric(
                                    errorText: "Enter valid number"),
                                (value) {
                                  if (_isCreditCard &&
                                      value != null &&
                                      value != "") {
                                    if (double.parse(_formKey.currentState!
                                            .fields['CREDIT_LIMIT']?.value) <
                                        double.parse(value)) {
                                      return "Outstanding balance can not be greater than Credit Limit";
                                    }
                                    return null;
                                  }
                                },
                                (value) {
                                  if (_isCreditCard &&
                                      value != null &&
                                      value != "") {

                                    double outStandingBalance = double.parse(value);
                                    double availableBalnce = double.parse(_formKey.currentState!
                                        .fields['AVAILABLE_BALANCE']?.value);
                                    double creditLimit = double.parse(_formKey.currentState!
                                        .fields['CREDIT_LIMIT']?.value);

                                    if((outStandingBalance + availableBalnce) != creditLimit) {
                                      return "Enter valid amount";
                                    }
                                    return null;
                                  }
                                }
                              ]),
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
                            initialValue: snapshot.data!.first.description,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Account not found"),
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
            _accountService
                .getAccountByName(
                    _formKey.currentState?.fields["ACCOUNT_NAME"]?.value)
                .then(
              (accountList) async {
                if (accountList.isNotEmpty && accountList[0].id != widget.id) {
                  showDialog(
                      context: context,
                      builder: (context) => const ErrorDialogWidget(
                          'Account with same name already exists'));
                } else {
                  await _accountService
                      .updateAccount(_formKey.currentState?.value,
                          _isCreditCard, widget.id)
                      .then(
                        (value) => {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountDetail(widget.id),
                            ),
                          )
                        },
                      );
                }
              },
            );
          }
        },
      ),
    );
  }
}
