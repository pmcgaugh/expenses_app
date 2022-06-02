import 'package:expenses_app/widgets/adaptive_flatbutton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction(this._addNewTransaction, {Key? key}) : super(key: key);

  final Function _addNewTransaction;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final _enteredTitle = _titleController.text;
    final _enteredAmount = double.tryParse(_amountController.text) ?? 0;
    if (_enteredTitle.isEmpty || _enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget._addNewTransaction(_enteredTitle, _enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(Duration(days: 30)),
    ).then((date) {
      if (date == null) return;
      setState(() {
        _selectedDate = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 10,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked date: ${DateFormat.yMd().format(_selectedDate!)}'),
                    ),
                    AdaptiveFlatbutton(_presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                  onPressed: _submitData,
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button!.color,
                  child: Text(
                    'Add Transaction',
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
