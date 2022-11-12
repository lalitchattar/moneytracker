import 'package:flutter/material.dart';
import 'package:moneytracker/model/transactions.dart';
import 'package:moneytracker/service/transaction_service.dart';
import 'package:moneytracker/util/utils.dart';

import '../home.dart';

class TransactionDetails extends StatefulWidget {
  final int id;
  const TransactionDetails(this.id, {Key? key}) : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {

  final TransactionService _transactionService = TransactionService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Transaction Detail"),
        centerTitle: false,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Home())).then((value) => setState((){}));
          }, icon: const Icon(Icons.edit)),
          IconButton(onPressed: (){
            //_showDeleteConfirmationDialog(widget.id);
          }, icon: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Transactions>>(
          future: _transactionService.getTransactionsById(widget.id),
          builder: (BuildContext context, AsyncSnapshot<List<Transactions>> snapshot) {
            if(snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(width: 1, color: Colors.grey),
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    snapshot.data!.first.categoryName!.substring(0, 1),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(snapshot.data!.first.categoryName!),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Chip(label: Text(Utils.formatNumber(snapshot.data!.first.finalAmount)))
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(width: 1, color: Colors.grey),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 5.0,),
                            ListTile(
                              leading: const Text("Date"),
                              trailing: Text(Utils.formatDate(snapshot.data!.first.dateAndTime)),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -1),
                            ),
                            const Divider(thickness: 2),
                            ListTile(
                              leading: const Text("Time"),
                              trailing: Text(Utils.formatTime(snapshot.data!.first.dateAndTime)),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -1),
                            ),
                            const Divider(thickness: 2),
                            ListTile(
                              leading: snapshot.data!.first.transactionType == "I" ? const Text("To Account") : const Text("From Account"),
                              trailing: Text(snapshot.data!.first.accountName!),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -1),
                            ),
                            const Divider(thickness: 2),
                            ListTile(
                              leading: const Text("Details"),
                              trailing: Text(snapshot.data!.first.description ?? "---"),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text("No Account Details Found"),);
            }
          },
        ),
      ),
    );
  }
}
