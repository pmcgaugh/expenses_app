import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transactions,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transactions;
  final Function deleteTransaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor = Colors.yellow;

  @override
  void initState() {
    const availalbeColors = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple,
    ];
    _bgColor = availalbeColors[Random().nextInt(availalbeColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FittedBox(
              child: Text('\$${widget.transactions.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          widget.transactions.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transactions.date),
        ),
        trailing: MediaQuery.of(context).size.width > 400
            ? FlatButton.icon(
                onPressed: () =>
                    widget.deleteTransaction(widget.transactions.id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                label: Text('Remove'),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                onPressed: () =>
                    widget.deleteTransaction(widget.transactions.id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              ),
      ),
    );
  }
}
