import 'package:flutter/material.dart';

import '../models/transaction.dart';

class NewTransaction extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final void Function(Transaction newTransaction) onAddTransaction;

  NewTransaction({this.onAddTransaction});

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
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            FlatButton(
              child: Text('Add Transaction'),
              textColor: Colors.purple,
              onPressed: () => onAddTransaction(Transaction(
                id: DateTime.now().toString(),
                title: titleController.text,
                amount:
                    double.parse(amountController.text.replaceAll(',', '.')),
                date: DateTime.now(),
              )),
            )
          ],
        ),
      ),
    );
  }
}
