import 'package:flutter/material.dart';
import 'package:moneytracker/screen/accounts/list_account.dart';
import 'package:moneytracker/screen/category/list_category.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("More"),
          centerTitle: false,
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(width: 1, color: Colors.grey),
                  ),
                  color: Colors.white,
                  child: const ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                    leading: CircleAvatar(
                      radius: 50.0,
                      child: Text("LA"),
                    ),
                    title: Text("Lalit Chattar"),
                    subtitle: Text("+91-9654402211"),
                    trailing: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(width: 1, color: Colors.grey),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: Wrap(
                      runSpacing: -5,
                      children: [
                        Row(
                          children: const [
                            Text(
                              "Fianance",
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        ListTile(
                            leading: const Icon(Icons.account_box),
                            title: const Text("Accounts"),
                            subtitle: const Text("Manage accounts and wallets"),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ListAccount()));
                            }),
                        const Divider(thickness: 2),
                        ListTile(
                          leading: const Icon(Icons.account_box),
                          title: const Text("Categories"),
                          subtitle: const Text("Manage categories"),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const ListCategory()));
                          },
                        ),
                        const Divider(thickness: 2),
                        const ListTile(
                          leading: Icon(Icons.account_box),
                          title: Text("Sources & Merchants"),
                          subtitle: Text("Manage sources & merchants"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(thickness: 2),
                        const ListTile(
                          leading: Icon(Icons.account_box),
                          title: Text("Assets"),
                          subtitle: Text("Manage assets"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(thickness: 2),
                        const ListTile(
                          leading: Icon(Icons.account_box),
                          title: Text("Savings & Loans"),
                          subtitle: Text("Manage Savings & Loans"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(thickness: 2),
                        const ListTile(
                          leading: Icon(Icons.account_box),
                          title: Text("Lends & Borrow"),
                          subtitle: Text("Manage lend & borrow"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(thickness: 2),
                        const ListTile(
                          leading: Icon(Icons.account_box),
                          title: Text("Transaction"),
                          subtitle: Text("Manage transaction"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(width: 1, color: Colors.grey),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: Wrap(
                      runSpacing: -5,
                      children: [
                        Row(
                          children: const [
                            Text(
                              "System & Preference",
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        const ListTile(
                          leading: Icon(Icons.account_box),
                          title: Text("Account"),
                          subtitle: Text("Manage lend & borrow"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(thickness: 2),
                        const ListTile(
                          leading: Icon(Icons.account_box),
                          title: Text("Account"),
                          subtitle: Text("Manage lend & borrow"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(thickness: 2),
                        const ListTile(
                          leading: Icon(Icons.account_box),
                          title: Text("Account"),
                          subtitle: Text("Manage lend & borrow"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
