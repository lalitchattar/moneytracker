import 'package:flutter/material.dart';
import 'package:moneytracker/screen/accounts/list_account_screen.dart';
import 'package:svg_icon/svg_icon.dart';

import '../../model/account.dart';
import '../../service/account_service.dart';
import '../../service/transaction_service.dart';
import '../../util/application_config.dart';
import '../../util/constants.dart';
import '../../util/utils.dart';
import '../../widget/error_dialog_widget.dart';
import 'edit_account_screen.dart';

class DetailAccountScreen extends StatefulWidget {
  final int id;
  const DetailAccountScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<DetailAccountScreen> createState() => _DetailAccountScreenState();
}

class _DetailAccountScreenState extends State<DetailAccountScreen> {
  final AccountService _accountService = AccountService();
  final TransactionService _transactionService = TransactionService();
  final ApplicationConfig _applicationConfig = ApplicationConfig();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Utils.getColorFromColorCode(Constants.screenBackgroundColor),
          appBar: AppBar(
            title: const Text(
              Constants.detailAccountScreenAppBarTitle,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccountScreen(widget.id))).then((value) => setState(() {}));
                },
                icon: const Icon(Icons.edit),
              ),
              _buildPopupMenuButton()
            ],
          ),
          body: FutureBuilder<List<Account>>(
            future: _accountService.getAccountById(widget.id),
            builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
              if (snapshot.hasData) {
                Account? account = snapshot.data?.first;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                    child: _getAccountTypeIcon(account!),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  account!.accountName,
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
                                          Constants.availableBalanceLabel,
                                        ),
                                        Text(
                                          Utils.formattedMoney(account.availableBalance, _applicationConfig.configMap!["CURRENCY"]!)

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
                                          Constants.descriptionLabel,
                                        ),
                                        Text(
                                          account.description ?? Constants.noInfo,
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
                                          Constants.inTransaction,
                                        ),
                                        Text(
                                          account.inTransaction.toString(),
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
                                          Constants.outTransaction,
                                        ),
                                        Text(
                                          account.outTransaction.toString(),
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
                                          Constants.creditedAmount,
                                        ),
                                        Text(
                                            Utils.formattedMoney(account.creditedAmount, _applicationConfig.configMap!["CURRENCY"]!)
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
                                          Constants.debitedAmount,
                                        ),
                                        Text(
                                            Utils.formattedMoney(account.debitedAmount, _applicationConfig.configMap!["CURRENCY"]!)
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: _isCreditCard(account),
                                      child: const Divider(
                                        thickness: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account),
                                child: const SizedBox(
                                  height: 12.0,
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constants.creditLimitLabel,
                                          ),
                                          Text(
                                              Utils.formattedMoney(account.creditLimit, _applicationConfig.configMap!["CURRENCY"]!)
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
                                visible: _isCreditCard(account),
                                child: const SizedBox(
                                  height: 12.0,
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constants.outStandingBalance,
                                          ),
                                          Text(
                                              Utils.formattedMoney(account.outstandingBalance, _applicationConfig.configMap!["CURRENCY"]!)
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
                                visible: _isCreditCard(account),
                                child: const SizedBox(
                                  height: 12.0,
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constants.billingDayLabel,
                                          ),
                                          Text(
                                            account.billingDay ?? Constants.noInfo,
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
                                visible: _isCreditCard(account),
                                child: const SizedBox(
                                  height: 12.0,
                                ),
                              ),
                              Visibility(
                                visible: _isCreditCard(account),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            Constants.gracePeriodLabel,
                                          ),
                                          Text(
                                            account.gracePeriod ?? Constants.noInfo,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
                  child: Text(Constants.noAccountFound),
                );
              }
            },
          )),
    );
  }

  bool _isCreditCard(Account account) {
    return account.isCreditCard == 1 ? true : false;
  }

  SvgIcon _getAccountTypeIcon(Account account) {
    return account.isCreditCard == 1
        ? const SvgIcon(
            "assets/icons/creditcard.svg",
            color: Colors.white,
            width: 50.0,
            height: 50.0,
          )
        : const SvgIcon(
            "assets/icons/bank.svg",
            color: Colors.white,
            width: 50.0,
            height: 50.0,
          );
  }

  PopupMenuButton _buildPopupMenuButton() {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (context) {
        return const [
          PopupMenuItem<int>(
            value: 0,
            child: Text(Constants.suspend),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Text(Constants.delete),
          ),
        ];
      },
      onSelected: (value) async {
        if (value == 0) {
          await _showSuspendConfirmationDialog(widget.id);
        } else if (value == 1) {
          await _showDeleteConfirmationDialog(widget.id);
        }
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            Constants.confirm,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(Constants.areYouSureToDelete),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(Constants.no, style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                Constants.yes,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _transactionService.getTransactionCountByAccountId(id).then((value) {
                  if (value == 0) {
                    _accountService.deleteAccount(id);
                    Navigator.pop(context);
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListAccountScreen(),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                    showDialog(context: context, builder: (context) => const ErrorDialogWidget(Constants.accountCanNotBeDeletedAsTransactionExists));
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuspendConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            Constants.confirm,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(Constants.areYouSureToSuspend),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(Constants.no, style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                Constants.yes,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _accountService.toggleSuspendAccount(id, 1);
                Navigator.pop(context);
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListAccountScreen(),
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
