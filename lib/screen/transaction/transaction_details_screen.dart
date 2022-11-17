import 'package:flutter/material.dart';

import '../../model/transactions.dart';
import '../../service/transaction_service.dart';
import '../../util/constants.dart';
import '../../util/utils.dart';

class TransactionDetailScreen extends StatefulWidget {
  final int id;
  const TransactionDetailScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {

  final TransactionService _transactionService = TransactionService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Utils.getColorFromColorCode(Constants.screenBackgroundColor),
      appBar: AppBar(
        title: Text(
          Constants.detailTransactionScreenAppBarTitle,
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
      body: FutureBuilder<List<Transactions>>(
        future: _transactionService.getTransactionsById(widget.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<Transactions>> snapshot) {
          if (snapshot.hasData) {
            Transactions? transactions = snapshot.data?.first;
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 0,
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundColor: Colors.deepPurple,
                                child: Text(transactions!.categoryName!
                                    .substring(0, 1)
                                    .toUpperCase(),),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: Text(
                              _getTransactionTypeByCode(transactions!.transactionType),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      Constants.descriptionLabel,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
                                    ),
                                    Text(
                                      transactions.description ?? Constants.noInfo,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
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
                            height: 12.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _getFromOrToAccountByCode(transactions.transactionType),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
                                    ),
                                    Text(
                                      transactions.accountName ?? Constants.noInfo,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
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
                            height: 12.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      Constants.categoryNameLabel,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
                                    ),
                                    Text(
                                      transactions.categoryName ?? Constants.noInfo,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
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
                            height: 12.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      Constants.transactionDate,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
                                    ),
                                    Text(
                                       Utils.formatDate(transactions.dateAndTime),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
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
                            height: 12.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      Constants.transactionTime,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
                                    ),
                                    Text(
                                      Utils.formatTime(transactions.dateAndTime),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
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
                            height: 12.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      Constants.transactionAmount,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,),
                                    ),
                                    Text(
                                      Utils.formatNumber(transactions.finalAmount),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1, color: _getBalanceColor(transactions)),
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
              ),
            );
          } else {
            return const Center(
              child: Text("No Account Details Found"),
            );
          }
        },
      ),
    );
  }

  String _getTransactionTypeByCode(String type) {
    if(type == Constants.incomeCode) {
        return Constants.income;
    } else {
      return Constants.expense;
    }
  }

  String _getFromOrToAccountByCode(String type) {
    if(type == Constants.incomeCode) {
      return Constants.toAccountLabel;
    } else {
      return Constants.fromAccountLabel;
    }
  }

  Color _getBalanceColor(Transactions transaction) {
    return transaction.transactionType == "I" ? Colors.green : Colors.red;
  }
}
