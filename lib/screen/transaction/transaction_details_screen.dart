import 'package:flutter/material.dart';
import 'package:svg_icon/svg_icon.dart';

import '../../model/transactions.dart';
import '../../service/transaction_service.dart';
import '../../util/application_config.dart';
import '../../util/category_icon_mapping.dart';
import '../../util/constants.dart';
import '../../util/utils.dart';

class TransactionDetailScreen extends StatefulWidget {
  final int id;
  const TransactionDetailScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final TransactionService _transactionService = TransactionService();
  final ApplicationConfig _applicationConfig = ApplicationConfig();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: const Text(
            Constants.detailTransactionScreenAppBarTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Transactions>>(
          future: _transactionService.getTransactionsById(widget.id),
          builder: (BuildContext context, AsyncSnapshot<List<Transactions>> snapshot) {
            if (snapshot.hasData) {
              Transactions? transactions = snapshot.data?.first;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
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
                                  child: _getSVGIconOrLetter(transactions!),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Center(
                              child: Text(
                                _getTransactionTypeByCode(transactions!.transactionType),
                                style: const TextStyle(fontWeight: FontWeight.w500, letterSpacing: 1.0),
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
                                        Constants.descriptionLabel,
                                      ),
                                      Text(
                                        transactions.description ?? Constants.noInfo
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
                            Visibility(
                              visible: _hideWidgetBasedOnTransactionType(Constants.expenseCode, transactions),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          Constants.fromAccountLabel,
                                        ),
                                        Text(
                                          transactions.fromAccountName!,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _hideWidgetBasedOnTransactionType(Constants.transferCode, transactions),
                              child: const SizedBox(
                                height: 12.0,
                              ),
                            ),
                            Visibility(
                              visible: _hideWidgetBasedOnTransactionType(Constants.incomeCode, transactions),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          Constants.toAccountLabel,
                                        ),
                                        Text(
                                          transactions.toAccountName!,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        Constants.categoryNameLabel,
                                      ),
                                      Text(
                                        transactions.transactionCategoryName ?? Constants.noInfo,
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
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        Constants.transactionDate,
                                      ),
                                      Text(
                                        Utils.formatDate(transactions.dateAndTime),
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
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        Constants.transactionTime,
                                      ),
                                      Text(
                                        Utils.formatTime(transactions.dateAndTime),
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
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        Constants.transactionAmount,
                                      ),
                                      Text(
                                        Utils.formattedMoney(transactions.finalAmount, _applicationConfig.configMap!["CURRENCY"]!),
                                        style: TextStyle(letterSpacing: 1, color: _getBalanceColor(transactions)),
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
      ),
    );
  }

  bool _hideWidgetBasedOnTransactionType(type, Transactions transactions) {
    if (type == transactions.transactionType || Constants.transferCode == transactions.transactionType) {
      return true;
    } else if (type == transactions.transactionType || Constants.transferCode == transactions.transactionType) {
      return true;
    } else {
      return false;
    }
  }

  String _getTransactionTypeByCode(String type) {
    if (type == Constants.incomeCode) {
      return Constants.income;
    } else if (type == Constants.expenseCode) {
      return Constants.expense;
    } else {
      return Constants.transfer;
    }
  }

  Color _getBalanceColor(Transactions transaction) {
    return transaction.transactionType == Constants.incomeCode ? Colors.green : Colors.red;
  }

  Widget _getSVGIconOrLetter(Transactions transaction) {
    if (CategoryIcon.icon[transaction.category] == null) {
      return Text(
        transaction.transactionCategoryName!.substring(0, 1),
        style: const TextStyle(fontSize: 25.0),
      );
    }
    return SvgIcon(
      CategoryIcon.icon[transaction.category]!,
      width: 50.0,
      height: 50.0,
    );
  }

  Widget _getTransactionTitle(Transactions transaction) {
    if (transaction.transactionType == Constants.transferCode) {
      return const Text(
        Constants.transfer,
        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Text(
          transaction.fromAccountName!.isEmpty ? transaction.toAccountName! : transaction.fromAccountName!,
          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
        ),
      );
    }
  }
}
