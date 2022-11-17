import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:moneytracker/screen/transaction/transaction_details.dart';
import 'package:moneytracker/screen/transaction/transaction_details_screen.dart';
import 'package:moneytracker/service/transaction_service.dart';

import '../model/transactions.dart';
import '../util/constants.dart';
import '../util/utils.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  static const _pageSize = 20;

  final PagingController<int, Transactions> _pagingController =
      PagingController(firstPageKey: 0);

  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchTransactions(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchTransactions(int offset) async {
    final newItems =
        await _transactionService.getTransactionsPageWise(_pageSize, offset);

    final isLastPage = newItems.length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = offset + newItems.length;
      _pagingController.appendPage(newItems, nextPageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: Text(
            Constants.listTransactionScreenAppBarTitle,
            style: TextStyle(
              color: Utils.getColorFromColorCode(Constants.appBarTitleColor),
            ),
          ),
          centerTitle: true,
          backgroundColor:
              Utils.getColorFromColorCode(Constants.appBarBackgroundColor),
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
            child: PagedListView<int, Transactions>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Transactions>(
                itemBuilder: (context, transaction, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TransactionDetailScreen(transaction.id!)));
                    },
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Text(transaction.categoryName!
                              .substring(0, 1)
                              .toUpperCase()),
                        ),
                        title: Text(
                          transaction.accountName!,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          transaction.categoryName!,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              Utils.formatDate(transaction.dateAndTime),
                            ),
                            Text(
                              Utils.formatNumber(transaction.finalAmount),
                              style: TextStyle(
                                  color: _getBalanceColor(transaction),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  MaterialColor _getBalanceColor(Transactions transaction) {
    return transaction.transactionType == "I" ? Colors.green : Colors.red;
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
