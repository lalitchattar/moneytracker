import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/model/budget_model.dart';
import 'package:moneytracker/service/budget_service.dart';
import 'package:moneytracker/util/utils.dart';

class Budget extends StatefulWidget {
  final bool isBudgetExists;
  final bool forYear;
  final bool noTransaction;
  const Budget(this.isBudgetExists, this.forYear, this.noTransaction, {Key? key}) : super(key: key);

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  final _formKey = GlobalKey<FormBuilderState>();
  final BudgetService _budgetService = BudgetService();

  late String _fromDate;
  late String _toDate;

  @override
  void initState() {
    if (widget.forYear) {
      _fromDate = "${DateFormat.y().format(DateTime.now())}-01-01";
      _toDate = "${DateFormat.y().format(DateTime.now())}-12-31";
    } else {
      _fromDate =
          "${DateFormat.y().format(DateTime.now())}-${DateFormat.M().format(DateTime.now())}-01";
      _toDate =
          "${DateFormat.y().format(DateTime.now())}-${DateFormat.M().format(DateTime.now())}-31";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Transaction"),
          centerTitle: false,
        ),
        body:
            widget.isBudgetExists ? showBudgetScreen() : showAddBudgetScreen());
  }

  Widget showAddBudgetScreen() {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            _showSetBudgetDialog();
          },
          child: const Text("Set Budget")),
    );
  }

  Widget showBudgetScreen() {
    return FutureBuilder<List<BudgetModel>>(
        future: _budgetService.getDataForBudgetChart(_fromDate, _toDate, 'E'),
        builder:
            (BuildContext context, AsyncSnapshot<List<BudgetModel>> snapshot) {
          if (snapshot.hasData && !widget.noTransaction) {
            return SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(width: 1, color: Colors.grey),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(children: [
                          DChartPie(
                            data: [
                              {
                                'domain': 'Spent',
                                'measure': Utils.calculateXPercentageOfY(
                                    snapshot.data?.first.expense ?? 0,
                                    snapshot.data?.first.budgetAmount ?? 0)
                              },
                              {
                                'domain': 'Remain',
                                'measure': (100 -
                                    Utils.calculateXPercentageOfY(
                                        snapshot.data?.first.expense ?? 0,
                                        snapshot.data?.first.budgetAmount ?? 0))
                              },
                            ],
                            fillColor: (pieData, index) {
                              switch (pieData['domain']) {
                                case 'Spent':
                                  return Colors.red;
                                case 'Remain':
                                  return Colors.blue;
                                case 'Ionic':
                                  return Colors.lightBlue;
                                default:
                                  return Colors.orange;
                              }
                            },
                            pieLabel: (pieData, index) {
                              return "${pieData['domain']}:\n${pieData['measure']}%";
                            },
                            labelPosition: PieLabelPosition.outside,
                            donutWidth: 20,
                          ),
                        ]),
                      ),
                    ),
                    ListTile(
                      leading: const Text("Budget"),
                      trailing: Text(snapshot.data?.first.budgetAmount.toString() ?? ""),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -3),
                    ),
                    const Divider(thickness: 2),
                    ListTile(
                      leading: const Text("Spent"),
                      trailing: Text(snapshot.data?.first.expense.toString() ?? ""),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -3),
                    ),
                    const Divider(thickness: 2),
                    ListTile(
                      leading: const Text("Exceed"),
                      trailing: Text(Utils.calculateExceedAmount(snapshot.data?.first.expense ?? 0, snapshot.data?.first.budgetAmount ?? 0).toString()),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -3),
                    ),
                    const Divider(thickness: 2),
                    Column(
                      children: [
                        ListTile(
                          leading: const Text("Transaction"),
                          trailing: Text(snapshot.data?.first.totalTransaction.toString() ?? ""),
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -3),
                        ),
                        const Divider(thickness: 2),
                        ListTile(
                          leading: const Text("Highest Spend"),
                          trailing: Text(snapshot.data?.first.highestAmount.toString() ?? ""),
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -3),
                        ),
                        const Divider(thickness: 2),
                        ListTile(
                          leading: const Text("Lowest Spend"),
                          trailing: Text(snapshot.data?.first.lowestAMount.toString() ?? ""),
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            if(widget.noTransaction) {
              return const Center(child: Text("No Transaction found for budget"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        });
  }

  Future<void> _showSetBudgetDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Set Budget',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: Container(
            height: 200.0,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                        "Budget for month ${DateFormat.MMMM().format(DateTime.now())}")
                  ],
                ),
                FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: "BUDGET_AMOUNT",
                          keyboardType: TextInputType.number,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Enter budget amount")
                          ]),
                        ),
                        FormBuilderCheckbox(
                          name: "FOR_YEAR",
                          initialValue: false,
                          title: const Text("Set Budget for complete year"),
                          valueTransformer: (value) {
                            return value! ? 1 : 0;
                          },
                        )
                      ],
                    ))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'DONE',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                  debugPrint(_formKey.currentState?.value.toString());
                  _budgetService
                      .createBudgetEntry(_formKey.currentState?.value)
                      .then((value) {
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
