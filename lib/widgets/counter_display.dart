import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';

class CounterDisplay extends StatelessWidget {
  final int counter;

  const CounterDisplay({
    super.key,
    required this.counter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      /*horizontal alignment for column*/
      // mainAxisAlignment: MainAxisAlignment.center,
      /*vertical alignment for column*/
      /*x or y depending on Column or Row*/
      children: <Widget>[
        Text('You have pushed the button this many times:',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.merge(TextStyle(color: AppConstants.primaryTextColor))),
        Text('$counter',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.merge(TextStyle(color: AppConstants.primaryTextColor))),
      ],
    );
  }
}
