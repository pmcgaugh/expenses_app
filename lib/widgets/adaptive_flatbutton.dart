import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatbutton extends StatelessWidget {
  final VoidCallback _onPressed;
  const AdaptiveFlatbutton(this._onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoButton(
            child: Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _onPressed)
        : FlatButton(
            onPressed: _onPressed,
            textColor: Theme.of(context).primaryColor,
            child: Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
