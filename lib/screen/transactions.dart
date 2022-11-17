import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:moneytracker/screen/transaction/transaction_details.dart';
import 'package:moneytracker/util/utils.dart';
import '../model/transactions.dart';
import '../service/transaction_service.dart';

class TransactionsScreen1 extends StatefulWidget {
  const TransactionsScreen1({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen1> createState() => _Transactions1ScreenState();
}

class _Transactions1ScreenState extends State<TransactionsScreen1> {
  static const _pageSize = 20;

  final PagingController<int, Transactions> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchTransactions(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchTransactions(int offset) async {
    final newItems =
        await TransactionService().getTransactionsPageWise(_pageSize, offset);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction"),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, Transactions>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Transactions>(
              itemBuilder: (context, transaction, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetails(transaction.id!)));
              },
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child:
                        Text(transaction.categoryName!.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(transaction.accountName!),
                  subtitle: Text(transaction.categoryName!),
                  trailing: Chip(
                    backgroundColor: transaction.transactionType == "I" ? Colors.green : Colors.red,
                    label: Text(
                        Utils.formatNumber(transaction.finalAmount).toString()),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
