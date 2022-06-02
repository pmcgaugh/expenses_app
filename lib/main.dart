import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        //platform: TargetPlatform.iOS,
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple, secondary: Colors.amber),
        accentColor: Colors.amber,
        fontFamily: 'Comic Code',
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime date) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: date,
      id: const Uuid().v4(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      double avail_height, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (input) {
                setState(() {
                  _showChart = input;
                });
              })
        ],
      ),
      _showChart
          ? Container(
              height: avail_height * 0.7, child: Chart(_recentTransactions))
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(double avail_height, Widget txListWidget) {
    return [
      Container(height: avail_height * 0.3, child: Chart(_recentTransactions)),
      txListWidget
    ];
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  AppBar _materialAppBar() {
    return AppBar(
      title: Text(
        'Personal Expenses',
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
  }

  CupertinoNavigationBar _cupertinoAppBar() {
    return CupertinoNavigationBar(
      middle: Text(
        'Personal Expenses',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final _appBar = _materialAppBar();

    final _CupertinoAppBar = _cupertinoAppBar();

    final _appBarHeight = Platform.isIOS
        ? _CupertinoAppBar.preferredSize.height
        : _appBar.preferredSize.height;

    final _availableHeight = (MediaQuery.of(context).size.height -
        _appBarHeight -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.top));

    final _txListWidget = Container(
        height: _availableHeight * 0.7, // 0.7
        child: TransactionList(_userTransactions, _deleteTransaction));

    final _pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLandscape)
              ..._buildLandscapeContent(_availableHeight, _txListWidget),
            if (!_isLandscape)
              ..._buildPortraitContent(_availableHeight, _txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _pageBody,
            navigationBar: _CupertinoAppBar,
          )
        : Scaffold(
            appBar: _appBar,
            body: _pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? Container()
                    : FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () => _startAddNewTransaction(context),
                      ),
          );
  }
}
