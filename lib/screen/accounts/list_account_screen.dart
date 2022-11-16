import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moneytracker/model/account.dart';
import 'package:moneytracker/screen/accounts/account_details_screen.dart';
import 'package:moneytracker/screen/accounts/add_account_screen.dart';
import 'package:moneytracker/screen/accounts/detail_account_screen.dart';
import 'package:moneytracker/screen/accounts/suspended_detail_account_screen.dart';
import '../../service/account_service.dart';

import '../../util/constants.dart';
import '../../util/utils.dart';
import 'add_account.dart';

class ListAccountScreen extends StatefulWidget {
  const ListAccountScreen({Key? key}) : super(key: key);

  @override
  State<ListAccountScreen> createState() => _ListAccountScreenState();
}

class _ListAccountScreenState extends State<ListAccountScreen> {
  final AccountService _accountService = AccountService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: Text(
            Constants.listAccountScreenAppBarTitle,
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
        body: FutureBuilder<List<Account>>(
          future: _accountService.getAllAccounts(true),
          builder:
              (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100), //
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Account account = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 0,
                        child: GestureDetector(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            tileColor: _getTileColor(account),
                            leading: _getAccountTypeIcon(account),
                            title: Text(account.accountName, style: const TextStyle(fontWeight: FontWeight.w500)),
                            trailing: Text(
                              Utils.formatNumber(account.availableBalance),
                              style: TextStyle(
                                color: _getBalanceColor(account),
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => _getDetailScreenBasedOnSuspendStatus(account)))
                                .then((value) => setState(() {}));
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: SpeedDial(
          spacing: 5.0,
          icon: Icons.add,
          backgroundColor: Colors.deepPurple,
          onPress: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddAccountScreen()))
                .then((value) => setState(() {}));
          },
        ),
      ),
    );
  }

  MaterialColor _getBalanceColor(Account account) {
    return account.availableBalance > 0
        ? Colors.green
        : Colors.red;
  }

  Icon _getAccountTypeIcon(Account account) {
    return account.isCreditCard == 1
        ? const Icon(Icons.credit_card, size: 30, color: Colors.deepPurple,)
        : const Icon(Icons.account_balance, size: 30, color: Colors.deepPurple,);
  }

  Color _getTileColor(Account account) {
    return account.isSuspended == 1 ? Utils.getColorFromColorCode(
        Constants.listSuspendedListTileColor) : Utils.getColorFromColorCode(
        Constants.lisListTileColor);
  }

  Widget _getDetailScreenBasedOnSuspendStatus(Account account) {
    return account.isSuspended == 1 ? SuspendedDetailAccountScreen(account.id) : DetailAccountScreen(account.id);
  }
}
