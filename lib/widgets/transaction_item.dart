import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required Transaction transaction,
    @required Function(String id) deleteTransaction,
  })  : _transaction = transaction,
        _deleteTransaction = deleteTransaction,
        super(key: key);

  final Transaction _transaction;
  final Function(String id) _deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: FittedBox(child: Text('\$${_transaction.amount}')),
            ),
          ),
          title: Text(
            _transaction.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            DateFormat.yMMMd().format(_transaction.date),
          ),
          trailing: MediaQuery.of(context).size.width > 460
              ? FlatButton.icon(
                  onPressed: () => _deleteTransaction(_transaction.id),
                  textColor: Theme.of(context).errorColor,
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                )
              : IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () => _deleteTransaction(_transaction.id),
                )),
    );
  }
}
