import 'dart:io';

import 'package:expense_planner/widgets/adaptive_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class NewTransaction extends StatefulWidget {
  final void Function(Transaction newTransaction) onAddTransaction;

  NewTransaction({this.onAddTransaction});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _addTransaction() {
    if (_amountController.text.isEmpty || _amountController.text.isEmpty) {
      return;
    }
    final String title = _titleController.text;
    final double amount = double.parse(
      _amountController.text.replaceAll(',', '.'),
    );

    if (title.isEmpty || amount <= 0 || _selectedDate == null) {
      return;
    }

    widget.onAddTransaction(Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: _selectedDate,
    ));

    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
              onSubmitted: (_) => _addTransaction(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _addTransaction(),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date chosen'
                          : 'Picked date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  AdaptiveFlatButton('Choose date', _showDatePicker),
                ],
              ),
            ),
            RaisedButton(
              child: const Text('Add Transaction'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
              onPressed: _addTransaction,
            )
          ],
        ),
      ),
    );
  }
}
