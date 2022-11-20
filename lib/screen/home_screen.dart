import 'package:flutter/material.dart';
import 'package:moneytracker/model/transactions.dart';
import 'package:svg_icon/svg_icon.dart';

import '../service/transaction_service.dart';
import '../util/category_icon_mapping.dart';
import '../util/constants.dart';
import '../util/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TransactionService _transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            Constants.appName,
            style: TextStyle(
              color: Utils.getColorFromColorCode(
                  Constants.defaultThemeAppBarTitleColor),
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
              Utils.getColorFromColorCode(Constants.defaultThemeColor),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 150.0,
                decoration: BoxDecoration(
                  color:
                      Utils.getColorFromColorCode(Constants.defaultThemeColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 1.0,
                      color: Utils.getColorFromColorCode(
                          Constants.defaultHomePageMainContainerColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(width: 0, color: Colors.grey),
                      ),
                      child: SizedBox(
                        height: 250.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 18.0),
                              child: ListTile(
                                title: Text(
                                  "Total Balance",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.0),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    "3435.00",
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        color: Colors.black,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 1.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: const BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child:
                                            const Icon(Icons.account_balance),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      const Text("Expense")
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child:
                                            const Icon(Icons.account_balance),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      const Text("Income")
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child:
                                            const Icon(Icons.account_balance),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      const Text("Transfer")
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: const BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child:
                                            const Icon(Icons.account_balance),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      const Text("Budget")
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:
                                const BorderSide(width: 0, color: Colors.grey),
                          ),
                          child: Container(
                            width: 180.0,
                            height: 90.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20.0,
                                    top: 20.0,
                                  ),
                                  child: Text(
                                    "Income",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, top: 10.0),
                                  child: Text(
                                    "80000.00",
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:
                                const BorderSide(width: 0, color: Colors.grey),
                          ),
                          child: SizedBox(
                            width: 180.0,
                            height: 90.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20.0,
                                    top: 20.0,
                                  ),
                                  child: Text(
                                    "Expenses",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, top: 10.0),
                                  child: Text(
                                    "80000.00",
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Latest Transactions",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    FutureBuilder(
                      future: _transactionService.getTransactionsPageWise(5, 0),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Transactions>> snapshot) {
                        if(snapshot.hasData) {
                          List<Widget> item = [];
                          snapshot.data?.forEach((transaction) {
                            item.add(
                                Card(
                                  child: ListTile(
                                    visualDensity: const VisualDensity(vertical: 4),
                                    leading: SizedBox(
                                      width: 60.0,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Utils.getColorFromColorCode(Constants.defaultThemeColor),
                                            child: _getSVGIconOrLetter(transaction),
                                          ),
                                          Text(
                                            transaction.transactionCategoryName!,
                                            style: const TextStyle(
                                                fontSize: 12.0, fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                    title: _getTransactionTitle(transaction),
                                    trailing: Text(
                                      Utils.formatNumber(transaction.finalAmount),
                                      style: TextStyle(
                                          color: _getBalanceColor(transaction),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                            );
                          },);
                         return Column(children: item,);
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  MaterialColor _getBalanceColor(Transactions transaction) {
    if(transaction.transactionType == "T") {
      return Colors.deepPurple;
    } else if(transaction.transactionType == "I") {
      return Colors.green;
    } else {
      return Colors.red;;
    }
  }

  Widget _getSVGIconOrLetter(Transactions transaction) {
    if (CategoryIcon.icon[transaction.category] == null) {
      return Text(transaction.transactionCategoryName!.substring(0, 1));
    }
    return SvgIcon(CategoryIcon.icon[transaction.category]!);
  }

  Widget _getTransactionTitle(Transactions transaction) {
    if (transaction.transactionType == "T") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Constants.from + transaction.fromAccountName.toString(), style: const TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.w500),),
          const SizedBox(height: 10,),
          Text(Constants.to + transaction.toAccountName.toString(), style: const TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.w500),),
        ],
      );
    } else {
      return Text(transaction.fromAccountName!.isEmpty ? transaction.toAccountName! : transaction.fromAccountName!, style: const TextStyle(
          fontSize: 15.0, fontWeight: FontWeight.w500),);
    }
  }
}
