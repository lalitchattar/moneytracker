import 'package:flutter/material.dart';

class ErrorDialogWidget extends StatefulWidget {
  final String message;
  const ErrorDialogWidget(this.message, {Key? key}) : super(key: key);

  @override
  State<ErrorDialogWidget> createState() => _ErrorDialogWidgetState();
}

class _ErrorDialogWidgetState extends State<ErrorDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Failure',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(widget.message),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
