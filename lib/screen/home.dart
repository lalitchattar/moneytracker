import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moneytracker/screen/transaction/expense/add_expense_transaction.dart';
import 'package:moneytracker/screen/transaction/income/add_income_transaction.dart';
import 'package:moneytracker/screen/transaction/transaction_details.dart';
import 'package:moneytracker/screen/transactions.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: false,
        ),
        body: Text("Hello"),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          spaceBetweenChildren: 4,
          children: [
            SpeedDialChild(
              label: "Income",
              child: const Icon(Icons.add),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddIncomeTransaction()));
              }
            ),
            SpeedDialChild(
                label: "Expense",
                child: const Icon(Icons.add),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpenseTransaction()));
                }
            )
          ],
        ));
  }
}
