import 'package:flutter/material.dart';

import '../models/transaction.dart';

class NewTransaction extends StatefulWidget {
  final void Function(Transaction newTransaction) onAddTransaction;

  NewTransaction({this.onAddTransaction});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void _addTransaction() {
    final String title = titleController.text;
    final double amount = double.parse(
      amountController.text.replaceAll(',', '.'),
    );

    if (title.isEmpty || amount <= 0) {
      return;
    }

    widget.onAddTransaction(Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
    ));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => _addTransaction(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _addTransaction(),
            ),
            FlatButton(
              child: Text('Add Transaction'),
              textColor: Colors.purple,
              onPressed: _addTransaction,
            )
          ],
        ),
      ),
    );
  }
}
