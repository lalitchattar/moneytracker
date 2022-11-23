import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/model/budget_model.dart';
import 'package:moneytracker/service/budget_service.dart';

import '../util/constants.dart';
import '../util/utils.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final BudgetService _budgetService = BudgetService();
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Constants.budget,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<List<BudgetModel>>(
          future: _budgetService.checkBudgetExists(),
          builder: (BuildContext context, AsyncSnapshot<List<BudgetModel>> snapshot) {
            if (snapshot.data?.isNotEmpty ?? false) {
              return FutureBuilder<List<BudgetModel>>(
                future: _budgetService.getDataForBudgetChart(
                    _getFromDate(snapshot.data!.first.forYear), _getToDate(snapshot.data!.first.forYear), Constants.expenseCode),
                builder: (BuildContext context, AsyncSnapshot<List<BudgetModel>> snapshot) {
                  if (snapshot.data?.isNotEmpty ?? false) {
                    BudgetModel budgetModel = snapshot.data!.first;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            elevation: 0,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Stack(children: [
                                      DChartPie(
                                        data: [
                                          {Constants.domain: Constants.spent, Constants.measure: _getSpendMeasure(budgetModel)},
                                          {Constants.domain: Constants.remain, Constants.measure: _getRemainMeasure(budgetModel)},
                                        ],
                                        fillColor: (pieData, index) {
                                          switch (pieData[Constants.domain]) {
                                            case Constants.spent:
                                              return Colors.red;
                                            case Constants.remain:
                                              return Colors.green;
                                            default:
                                              return Colors.orange;
                                          }
                                        },
                                        pieLabel: (pieData, index) {
                                          return "${pieData[Constants.domain]}:\n${pieData[Constants.measure]}%";
                                        },
                                        labelPosition: PieLabelPosition.outside,
                                        donutWidth: 20,
                                      ),
                                    ]),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constants.budget,
                                          ),
                                          Text(
                                            Utils.formatNumber(budgetModel.budgetAmount),
                                            style: const TextStyle( color: Colors.green),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constants.spent,
                                          ),
                                          Text(
                                            Utils.formatNumber(budgetModel.expense),
                                            style: const TextStyle( color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constants.exceed,
                                          ),
                                          Text(
                                            Utils.formatNumber(_calculateExceedAmount(budgetModel)),
                                            style: TextStyle(color: _getExceedColor(budgetModel)),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constants.transactions,
                                          ),
                                          Text(
                                            budgetModel.totalTransaction.toString(),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constants.highestSpend,
                                          ),
                                          Text(
                                            Utils.formatNumber(budgetModel.highestAmount),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constants.lowestSpend,
                                          ),
                                          Text(
                                            Utils.formatNumber(budgetModel.lowestAmount),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        Constants.noTransactionFoundToSetBudget,
                      ),
                    );
                  }
                },
              );
            } else {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showSetBudgetDialog();
                  },
                  child: const Text(
                    Constants.addBudget,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _showSetBudgetDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            Constants.addBudget,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SizedBox(
            height: 200.0,
            child: Column(
              children: [
                Row(
                  children: [Text(Constants.budgetFor + DateFormat.MMMM().format(DateTime.now()))],
                ),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: Constants.budgetAmount,
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: Constants.enterBudgetAmount)]),
                      ),
                      FormBuilderCheckbox(
                        name: Constants.forYear,
                        initialValue: false,
                        title: const Text(Constants.setBudgetForCompleteYear),
                        valueTransformer: (value) {
                          return value! ? 1 : 0;
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(Constants.cancel, style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                Constants.done,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                  debugPrint(_formKey.currentState?.value.toString());
                  _budgetService.createBudgetEntry(_formKey.currentState?.value).then(
                    (value) {
                      Navigator.pop(context);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  String _getFromDate(int forYear) {
    if (forYear == 1) {
      return "${DateFormat.y().format(DateTime.now())}-01-01";
    } else {
      return "${DateFormat.y().format(DateTime.now())}-${DateFormat.M().format(DateTime.now())}-01";
    }
  }

  String _getToDate(int forYear) {
    if (forYear == 1) {
      return "${DateFormat.y().format(DateTime.now())}-12-31";
    } else {
      return "${DateFormat.y().format(DateTime.now())}-${DateFormat.M().format(DateTime.now())}-31";
    }
  }

  double _getSpendMeasure(BudgetModel budgetModel) {
    return Utils.calculateXPercentageOfY(budgetModel.expense, budgetModel.budgetAmount);
  }

  double _getRemainMeasure(BudgetModel budgetModel) {
    return (100 - Utils.calculateXPercentageOfY(budgetModel.expense, budgetModel.budgetAmount)) <= 0
        ? 0
        : (100 - Utils.calculateXPercentageOfY(budgetModel.expense, budgetModel.budgetAmount));
  }

  double _calculateExceedAmount(BudgetModel budgetModel) {
    return Utils.calculateExceedAmount(budgetModel.expense, budgetModel.budgetAmount);
  }

  Color _getExceedColor(budgetModel) {
    return _calculateExceedAmount(budgetModel) > 0 ? Colors.red : Colors.green;
  }
}
