import 'package:flutter/material.dart';
import 'package:moneytracker/util/utils.dart';

import '../../model/account.dart';
import '../../service/account_service.dart';
import '../../service/transaction_service.dart';
import 'edit_account.dart';
import 'list_account.dart';

class SuspendedAccountDetails extends StatefulWidget {
  final int id;
  const SuspendedAccountDetails(this.id, {Key? key}) : super(key: key);

  @override
  State<SuspendedAccountDetails> createState() => _SuspendedAccountDetailsState();
}

class _SuspendedAccountDetailsState extends State<SuspendedAccountDetails> {

  final AccountService _accountService = AccountService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Details"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListAccount(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccount(widget.id))).then((value) => setState((){}));
          }, icon: const Icon(Icons.remove_red_eye)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Account>>(
          future: _accountService.getAccountById(widget.id),
          builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
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
                                    snapshot.data!.first.accountName.substring(0, 1),
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
                              child: Text(snapshot.data!.first.accountName),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                  "Balance: ${Utils.formatNumber(snapshot.data!.first.availableBalance)}"),
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
                              leading: const Text("Details"),
                              trailing: Text(snapshot.data!.first.description ?? "---"),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            const Divider(thickness: 2),
                            ListTile(
                              leading: const Text("In Transaction"),
                              trailing:
                              Text(snapshot.data!.first.inTransaction.toString()),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            const Divider(thickness: 2),
                            ListTile(
                              leading: const Text("Out Transaction"),
                              trailing: Text(
                                  snapshot.data!.first.outTransaction.toString()),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            const Divider(thickness: 2),
                            ListTile(
                              leading: const Text("Credited Amount"),
                              trailing: Text(
                                  Utils.formatNumber(snapshot.data!.first.creditedAmount).toString()),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            const Divider(thickness: 2),
                            ListTile(
                              leading: const Text("Debited Amount"),
                              trailing:
                              Text(Utils.formatNumber(snapshot.data!.first.debitedAmount).toString()),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                            ),
                            Visibility(
                              visible: (snapshot.data!.first.isCreditCard == 1)
                                  ? true
                                  : false,
                              child: const Divider(thickness: 2),
                            ),
                            Visibility(
                              visible: snapshot.data!.first.isCreditCard == 1
                                  ? true
                                  : false,
                              child: ListTile(
                                leading: const Text("Credit Limit"),
                                trailing: Text(
                                    Utils.formatNumber(snapshot.data!.first.creditLimit).toString()),
                                dense: true,
                                visualDensity: const VisualDensity(vertical: -3),
                              ),
                            ),
                            Visibility(
                              visible: (snapshot.data!.first.isCreditCard == 1)
                                  ? true
                                  : false,
                              child: const Divider(thickness: 2),
                            ),
                            Visibility(
                              visible: snapshot.data!.first.isCreditCard == 1
                                  ? true
                                  : false,
                              child: ListTile(
                                leading: const Text("Outstanding Balance"),
                                trailing: Text(
                                    Utils.formatNumber(snapshot.data!.first.outstandingBalance).toString()),
                                dense: true,
                                visualDensity: const VisualDensity(vertical: -3),
                              ),
                            ),
                            Visibility(
                              visible: (snapshot.data!.first.isCreditCard == 1)
                                  ? true
                                  : false,
                              child: const Divider(thickness: 2),
                            ),
                            Visibility(
                              visible: snapshot.data!.first.isCreditCard == 1
                                  ? true
                                  : false,
                              child: ListTile(
                                leading: const Text("Billing Cycle"),
                                trailing: snapshot.data!.first.billingDay == null ? const Text("---") : Text(
                                    snapshot.data!.first.billingDay.toString()),
                                dense: true,
                                visualDensity: const VisualDensity(vertical: -3),
                              ),
                            ),
                            Visibility(
                              visible: (snapshot.data!.first.isCreditCard == 1)
                                  ? true
                                  : false,
                              child: const Divider(thickness: 2),
                            ),
                            Visibility(
                              visible: snapshot.data!.first.isCreditCard == 1
                                  ? true
                                  : false,
                              child: ListTile(
                                leading: const Text("Grace Period"),
                                trailing: snapshot.data!.first.gracePeriod == null ? const Text("---") : Text(
                                    snapshot.data!.first.gracePeriod.toString()),
                                dense: true,
                                visualDensity: const VisualDensity(vertical: -3),
                              ),
                            ),
                            const SizedBox(height: 5.0,),
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
