import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:moneytracker/screen/transaction/transaction_details_screen.dart';
import 'package:moneytracker/service/transaction_service.dart';
import 'package:moneytracker/util/ThemeUtil.dart';
import 'package:moneytracker/util/category_icon_mapping.dart';
import 'package:svg_icon/svg_icon.dart';

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

  final PagingController<int, Transactions> _pagingController = PagingController(firstPageKey: 0);

  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchTransactions(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchTransactions(int offset) async {
    final newItems = await _transactionService.getTransactionsPageWise(_pageSize, offset);

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
        backgroundColor: Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: const Text(
            Constants.listTransactionScreenAppBarTitle,
          ),
          centerTitle: true,
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetailScreen(transaction.id!)));
                    },
                    child: Card(
                      child: ListTile(
                        visualDensity: const VisualDensity(vertical: 4),
                        leading: SizedBox(
                          width: 60.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                child: _getSVGIconOrLetter(transaction),
                              ),
                              Text(
                                transaction.transactionCategoryName!,
                                style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        title: _getTransactionTitle(transaction),
                        trailing: Text(
                          Utils.formatNumber(transaction.finalAmount),
                          style: TextStyle(color: _getBalanceColor(transaction), fontWeight: FontWeight.w600),
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
    if (transaction.transactionType == "T") {
      return generateMaterialColor(color: ThemeUtil.getDefaultThemeColor());
    } else if (transaction.transactionType == "I") {
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
      return Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Text(
          transaction.fromAccountName!.isEmpty ? transaction.toAccountName! : transaction.fromAccountName!,
          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
