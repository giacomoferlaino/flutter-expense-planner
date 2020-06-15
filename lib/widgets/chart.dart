import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;

  Chart(this._recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var transaction in _recentTransactions) {
        if (transaction.date.day == weekDay.day &&
            transaction.date.month == weekDay.month &&
            transaction.date.year == weekDay.year) {
          totalSum += transaction.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    });
  }

  double get _totalSpending {
    return groupedTransactionValues.fold(
        0.0, (previousValue, element) => previousValue + element['amount']);
  }

  double weeklyPercentage(
      Map<String, Object> transaction, double totalSpending) {
    if (totalSpending == 0.0) {
      return 0.0;
    }
    return (transaction['amount'] as double) / totalSpending;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((transaction) {
              return ChartBar(
                label: transaction['day'],
                spendingAmount: transaction['amount'],
                spendingWeeklyPercentage:
                    weeklyPercentage(transaction, _totalSpending),
              );
            }).toList()),
      ),
    );
  }
}
