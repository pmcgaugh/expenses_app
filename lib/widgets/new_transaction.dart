import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction(this._addNewTransaction, {Key? key}) : super(key: key);

  final Function _addNewTransaction;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void _submitData() {
    final _enteredTitle = titleController.text;
    final _enteredAmount = double.tryParse(amountController.text) ?? 0;
    if (_enteredTitle.isEmpty || _enteredAmount <= 0) return;
    widget._addNewTransaction(_enteredTitle, _enteredAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: true),
              onSubmitted: (_) => _submitData(),
            ),
            FlatButton(
                onPressed: _submitData,
                textColor: Colors.purple,
                child: Text(
                  'Add Transaction',
                ))
          ],
        ),
      ),
    );
  }
}
