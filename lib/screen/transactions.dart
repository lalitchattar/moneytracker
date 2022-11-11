import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

  @override
  void initState() {
    super.initState();
    debugPrint("Loading again........");
  }
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Transactions"),
    );
  }
}
