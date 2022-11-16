import 'package:flutter/material.dart';
import 'package:moneytracker/screen/category/list_category.dart';
import 'package:moneytracker/util/constants.dart';
import 'package:moneytracker/util/utils.dart';

import 'accounts/list_account.dart';
import 'accounts/list_account_screen.dart';
import 'category/list_category_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Utils.getColorFromColorCode(Constants.screenBackgroundColor),
        appBar: AppBar(
          title: Text(
            Constants.moreScreenAppBarTitle,
            style: TextStyle(
              color: Utils.getColorFromColorCode(Constants.appBarTitleColor),
            ),
          ),
          centerTitle: true,
          backgroundColor:
              Utils.getColorFromColorCode(Constants.appBarBackgroundColor),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Colors.white,
                  child: const ListTile(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      radius: 50.0,
                      child: Text("LA"),
                    ),
                    title: Text("Lalit Chattar"),
                    subtitle: Text("+91-9654402211"),
                    trailing: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Icon(Icons.arrow_forward_ios, color: Colors.deepPurple,),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Utils.getColorFromColorCode(
                      Constants.screenBackgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Wrap(
                      runSpacing: -5,
                      children: [
                        Row(
                          children: [
                            Text(
                              Constants.moreScreenFinanceText,
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: Utils.getColorFromColorCode(
                                      Constants.moreScreenSectionTitleColor),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Utils.getColorFromColorCode(Constants.moreScreenListTileColor),
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenAccountMenuText),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple,),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute( builder: (context) => const ListAccountScreen()));
                          },
                        ),
                        const Divider(
                          thickness: 1,
                          height: 0,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.white,
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenCategoryMenuText),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple,),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute( builder: (context) => const ListCategoryScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Utils.getColorFromColorCode(
                      Constants.screenBackgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Wrap(
                      runSpacing: -5,
                      children: [
                        Row(
                          children: [
                            Text(
                              Constants.moreScreenSettingsText,
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: Utils.getColorFromColorCode(
                                      Constants.moreScreenSectionTitleColor),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.white,
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenReminderText),
                          trailing: Switch(value: true, onChanged: (value){}, activeColor: Colors.deepPurple,),
                          onTap: () {},
                        ),
                        const Divider(
                          thickness: 1,
                          height: 0,
                        ),
                        ListTile(
                          enabled: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.white,
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenReminderTimeText),
                          trailing: const Text("12:30 PM"),
                          onTap: () {},
                        ),
                        const Divider(
                          thickness: 1,
                          height: 0,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.white,
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenCurrencyMenuText),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple,),
                          onTap: () {},
                        ),
                        const Divider(
                          thickness: 1,
                          height: 0,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.white,
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenBackupText),
                          onTap: () {},
                        ),
                        const Divider(
                          thickness: 1,
                          height: 0,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.white,
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenResetDataMenuText),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Utils.getColorFromColorCode(
                      Constants.screenBackgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Wrap(
                      runSpacing: -5,
                      children: [
                        Row(
                          children: [
                            Text(
                              Constants.moreScreenAboutText,
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: Utils.getColorFromColorCode(
                                      Constants.moreScreenSectionTitleColor),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.white,
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenFeedbackText),
                          onTap: () {},
                        ),
                        const Divider(
                          thickness: 1,
                          height: 0,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.white,
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenRateText),
                          onTap: () {},
                        ),
                        const Divider(
                          thickness: 1,
                          height: 0,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.white,
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenShareText),
                          onTap: () {},
                        ),
                        const Divider(
                          thickness: 1,
                          height: 0,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.white,
                          leading: const Icon(Icons.account_box),
                          title: const Text(Constants.moreScreenAboutText),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
