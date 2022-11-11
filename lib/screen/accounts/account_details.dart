import 'package:flutter/material.dart';
import 'package:moneytracker/model/account.dart';
import 'package:moneytracker/screen/accounts/edit_account.dart';
import 'package:moneytracker/screen/accounts/list_account.dart';
import 'package:moneytracker/service/account_service.dart';
import 'package:moneytracker/util/utils.dart';

class AccountDetail extends StatefulWidget {
  final int id;
  const AccountDetail(this.id, {Key? key}) : super(key: key);

  @override
  State<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {


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
          }, icon: const Icon(Icons.edit)),
          IconButton(onPressed: (){
            _showDeleteConfirmationDialog(widget.id);
          }, icon: const Icon(Icons.delete))
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
                                  "Available Balance: ${Utils.formatNumber(snapshot.data!.first.availableBalance)}"),
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
                                    "${snapshot.data!.first.billingDay.toString()} of Every month"),
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

  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Are you sure to delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('NO', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'YES',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _accountService.deleteAccount(id);
                Navigator.pop(context);
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListAccount(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
