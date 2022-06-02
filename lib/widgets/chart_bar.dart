import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String _label;
  final double _spendingAmount;
  final double _spendingOfPctTotal;

  const ChartBar(this._label, this._spendingAmount, this._spendingOfPctTotal,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text('\$${_spendingAmount.toStringAsFixed(0)}'))),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 30,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor:
                      _spendingOfPctTotal < 0.1 && _spendingOfPctTotal > 0
                          ? 0.1
                          : _spendingOfPctTotal,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.05),
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(child: Text(_label)))
        ],
      );
    });
  }
}
