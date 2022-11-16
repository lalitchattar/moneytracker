import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moneytracker/model/account.dart';
import 'package:moneytracker/screen/accounts/account_details_screen.dart';
import 'package:moneytracker/screen/accounts/suspended_account_details.dart';
import 'package:moneytracker/screen/more.dart';
import 'package:moneytracker/service/account_service.dart';
import 'package:moneytracker/util/utils.dart';

import 'add_account.dart';

class ListAccount extends StatefulWidget {
  const ListAccount({Key? key}) : super(key: key);

  @override
  State<ListAccount> createState() => _ListAccountState();
}

class _ListAccountState extends State<ListAccount> {
  final AccountService _accountService = AccountService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accounts"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const More(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder<List<Account>>(
          future: _accountService.getAllAccounts(true),
          builder:
              (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    foregroundDecoration: snapshot.data![index].isSuspended == 1 ? const BoxDecoration(
                      color: Colors.grey,
                      backgroundBlendMode: BlendMode.saturation,
                    ) : null,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => snapshot.data![index].isSuspended == 0 ? AccountDetail(
                                          snapshot.data![index].id ?? 0) : SuspendedAccountDetails(
                                          snapshot.data![index].id ?? 0)))
                              .then((value) => setState(() {}));
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                  (snapshot.data![index].isCreditCard == 1)
                                      ? Icons.credit_card
                                      : Icons.account_balance),
                            ),
                            title: Text(snapshot.data![index].accountName, style: const TextStyle(fontWeight: FontWeight.w500),),
                            trailing: Chip(
                              backgroundColor: snapshot.data![index].availableBalance! > 0 ? Colors.green: Colors.red,
                              label: Text(Utils.formatNumber(snapshot.data![index].availableBalance)
                                  .toString(), style: const TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        spacing: 5.0,
        icon: Icons.add,
        onPress: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddAccount()))
              .then((value) => setState(() {}));
        },
      ),
    );
  }
}
