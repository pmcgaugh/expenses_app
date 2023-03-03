import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;

  TransactionList(this.transactions, this._deleteTransaction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  FittedBox(
                    child: Text('No transactions added yet...',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.15),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          )
        : ListView(children: [
            ...transactions
                .map((tx) => TransactionItem(
                    key: ValueKey(tx.id),
                    transactions: tx,
                    deleteTransaction: _deleteTransaction))
                .toList()
          ]);
  }
}
