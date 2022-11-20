import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/model/transactions.dart';
import 'package:moneytracker/screen/transaction/expense/add_expense_transaction_screen.dart';
import 'package:moneytracker/screen/transaction/income/add_income_transaction_screen.dart';
import 'package:moneytracker/screen/transaction/transaction_details_screen.dart';
import 'package:moneytracker/screen/transaction/transfer/add_transfer_transaction_screen.dart';
import 'package:moneytracker/service/account_service.dart';
import 'package:moneytracker/util/ThemeUtil.dart';
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
  final AccountService _accountService = AccountService();

  final String _fromDate =
      "${DateFormat.y().format(DateTime.now())}-${DateFormat.M().format(DateTime.now())}-01";
  final String _toDate =
      "${DateFormat.y().format(DateTime.now())}-${DateFormat.M().format(DateTime.now())}-31";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text(
            Constants.appName,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 150.0,
                decoration: BoxDecoration(
                  color: ThemeUtil.getDefaultThemeColor(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(width: 0),
                      ),
                      child: SizedBox(
                        height: 250.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 18.0),
                              child: ListTile(
                                title: const Text(
                                  Constants.totalBalance,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.0),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: FutureBuilder<List>(
                                    future: _accountService.getTotalBalance(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List> snapshot) {
                                      if (snapshot.hasData) {
                                        String balance = Utils.formatNumber(
                                                snapshot.data?.first[Constants
                                                    .addAccountFormAvailableBalance]) ??
                                            Constants.initialBalance;
                                        return Text(
                                          balance,
                                          style: const TextStyle(
                                              fontSize: 30.0,
                                              color: Colors.black,
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w500),
                                        );
                                      } else {
                                        return const Text(
                                            Constants.initialBalance,
                                            style: TextStyle(
                                                fontSize: 30.0,
                                                color: Colors.black,
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.w500));
                                      }
                                    },
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
                                      GestureDetector(
                                        child: Container(
                                          height: 60.0,
                                          width: 60.0,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: const CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            child: SvgIcon(
                                              "assets/icons/expense.svg",
                                              color: Colors.white,
                                              width: 30, height: 30,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AddExpenseTransactionScreen()))
                                              .then((value) => setState(() {}));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      const Text(Constants.expense)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 60.0,
                                          width: 60.0,
                                          decoration: const BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: const CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            child: SvgIcon(
                                              "assets/icons/income.svg",
                                              color: Colors.white,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AddIncomeTransactionScreen()))
                                              .then((value) => setState(() {}));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      const Text(Constants.income)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 60.0,
                                          width: 60.0,
                                          decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: const CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            child: SvgIcon(
                                              "assets/icons/transfer.svg",
                                              color: Colors.white,
                                              width: 30, height: 30,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AddTransferTransactionScreen()))
                                              .then((value) => setState(() {}));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      const Text(Constants.transfer)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: const BoxDecoration(
                                            color: Colors.pink,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: SvgIcon(
                                            "assets/icons/budget.svg",
                                            color: Colors.white,
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      const Text(Constants.budget)
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
                        FutureBuilder(
                          future: _transactionService
                              .getTotalIncomeAndExpenseInDateRange(
                                  _fromDate, _toDate, Constants.incomeCode),
                          builder: (BuildContext context,
                              AsyncSnapshot<List> snapshot) {
                            if (snapshot.hasData) {
                              List? totalIncomeExpense = snapshot.data;
                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(
                                      width: 0, color: Colors.grey),
                                ),
                                child: SizedBox(
                                  width: 180.0,
                                  height: 90.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          left: 20.0,
                                          top: 20.0,
                                        ),
                                        child: Text(
                                          Constants.income,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 10.0),
                                        child: Text(
                                          _getBalance(totalIncomeExpense!),
                                          style: const TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        FutureBuilder(
                          future: _transactionService
                              .getTotalIncomeAndExpenseInDateRange(
                                  _fromDate, _toDate, Constants.expenseCode),
                          builder: (BuildContext context,
                              AsyncSnapshot<List> snapshot) {
                            if (snapshot.hasData) {
                              List? totalIncomeExpense = snapshot.data;
                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(
                                      width: 0, color: Colors.grey),
                                ),
                                child: SizedBox(
                                  width: 180.0,
                                  height: 90.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          left: 20.0,
                                          top: 20.0,
                                        ),
                                        child: Text(
                                          Constants.expense,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 10.0),
                                        child: Text(
                                          _getBalance(totalIncomeExpense!),
                                          style: const TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        Constants.latestTransaction,
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
                        if (snapshot.hasData) {
                          List<Widget> item = [];
                          snapshot.data?.forEach(
                            (transaction) {
                              item.add(GestureDetector(
                                child: Card(
                                  child: ListTile(
                                    visualDensity:
                                        const VisualDensity(vertical: 4),
                                    leading: SizedBox(
                                      width: 60.0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Utils.getColorFromColorCode(
                                                    Constants
                                                        .defaultThemeColor),
                                            child: _getSVGIconOrLetter(
                                                transaction),
                                          ),
                                          Text(
                                            transaction
                                                .transactionCategoryName!,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                    title: _getTransactionTitle(transaction),
                                    trailing: Text(
                                      Utils.formatNumber(
                                          transaction.finalAmount),
                                      style: TextStyle(
                                          color: _getBalanceColor(transaction),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionDetailScreen(
                                                  transaction.id)));
                                },
                              ));
                            },
                          );
                          return Column(
                            children: item,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
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
    if (transaction.transactionType == Constants.transferCode) {
      return Colors.deepPurple;
    } else if (transaction.transactionType == Constants.incomeCode) {
      return Colors.green;
    } else {
      return Colors.red;
      ;
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
          Text(
            Constants.from + transaction.fromAccountName.toString(),
            style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            Constants.to + transaction.toAccountName.toString(),
            style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else {
      return Text(
        transaction.fromAccountName!.isEmpty
            ? transaction.toAccountName!
            : transaction.fromAccountName!,
        style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
      );
    }
  }

  String _getBalance(List balanceList) {
    if (balanceList.isNotEmpty) {
      return Utils.formatNumber(balanceList[0][Constants.finalAmount]);
    }
    return Constants.initialBalance;
  }
}
