import 'dart:io';

import 'package:expense_planner/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // This limits the possible orientations for the application.
  // Limiting the orientation can be useful to prevent useless development.
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String _title = 'Personal Expenses';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.blueGrey,
        errorColor: Colors.red[900],
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: const TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                ),
              ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(_title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String _title;

  MyHomePage(this._title);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _transactions.where((transaction) {
      if (transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)))) {
        return true;
      }
      return false;
    }).toList();
  }

  void _addTransaction(Transaction newTransaction) {
    setState(() {
      _transactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  void _showTransactionModal(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builderContext) {
          return NewTransaction(onAddTransaction: _addTransaction);
        });
  }

  void toggleChart(bool val) {
    setState(() {
      _showChart = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(widget._title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _showTransactionModal(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(widget._title),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showTransactionModal(context),
              )
            ],
          );
    getTransactionListWidget(double heightPercentage) => Container(
          height: (mediaQuery.size.height) * heightPercentage -
              appBar.preferredSize.height -
              mediaQuery.padding.top,
          child: TransactionList(_recentTransaction, _deleteTransaction),
        );
    getChartWidget(double heightPercentage) => Container(
          height: (mediaQuery.size.height) * heightPercentage -
              appBar.preferredSize.height -
              mediaQuery.padding.top,
          child: Chart(_transactions),
        );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: toggleChart,
                  ),
                ],
              ),
            if (!isLandscape) getChartWidget(0.3),
            if (!isLandscape) getTransactionListWidget(0.7),
            if (isLandscape)
              _showChart ? getChartWidget(0.7) : getTransactionListWidget(0.7),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _showTransactionModal(context),
                  ),
          );
  }
}
