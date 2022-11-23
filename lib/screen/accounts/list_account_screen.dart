import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moneytracker/model/account.dart';
import 'package:moneytracker/screen/accounts/add_account_screen.dart';
import 'package:moneytracker/screen/accounts/detail_account_screen.dart';
import 'package:moneytracker/screen/accounts/suspended_detail_account_screen.dart';
import 'package:moneytracker/util/all_screen_icon.dart';
import 'package:moneytracker/util/application_config.dart';
import 'package:svg_icon/svg_icon.dart';
import '../../service/account_service.dart';

import '../../util/constants.dart';
import '../../util/utils.dart';

class ListAccountScreen extends StatefulWidget {
  const ListAccountScreen({Key? key}) : super(key: key);

  @override
  State<ListAccountScreen> createState() => _ListAccountScreenState();
}

class _ListAccountScreenState extends State<ListAccountScreen> {
  final AccountService _accountService = AccountService();
  final ApplicationConfig _applicationConfig = ApplicationConfig();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: const Text(
            Constants.listAccountScreenAppBarTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Account>>(
          future: _accountService.getAllAccounts(true),
          builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
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
                            visualDensity: const VisualDensity(vertical: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            tileColor: _getTileColor(account),
                            leading: CircleAvatar(
                              radius: 20.0,
                              child: _getAccountTypeIcon(account),
                            ),
                            title: Text(account.accountName,),
                            trailing: Text(
                              Utils.formattedMoney(account.availableBalance, _applicationConfig.configMap!["CURRENCY"].toString()),
                              style: TextStyle(color: _getBalanceColor(account), fontWeight: FontWeight.w500),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => _getDetailScreenBasedOnSuspendStatus(account)))
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
          onPress: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAccountScreen())).then((value) => setState(() {}));
          },
        ),
      ),
    );
  }

  MaterialColor _getBalanceColor(Account account) {
    return account.availableBalance > 0 ? Colors.green : Colors.red;
  }

  SvgIcon _getAccountTypeIcon(Account account) {
    return account.isCreditCard == 1
        ? const SvgIcon(
            AllScreenIcon.creditCard,
            color: Colors.white,
          )
        : const SvgIcon(
            AllScreenIcon.bank,
            color: Colors.white,
          );
  }

  Color _getTileColor(Account account) {
    return account.isSuspended == 1
        ? Utils.getColorFromColorCode(Constants.listSuspendedListTileColor)
        : Utils.getColorFromColorCode(Constants.lisListTileColor);
  }

  Widget _getDetailScreenBasedOnSuspendStatus(Account account) {
    return account.isSuspended == 1 ? SuspendedDetailAccountScreen(account.id) : DetailAccountScreen(account.id);
  }
}
