import 'package:flutter/material.dart';
import 'algo_choice.dart';

void main() => runApp(StyleTransfer());

class StyleTransfer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AlgoChoice.id,
      routes: {
        AlgoChoice.id: (context) => AlgoChoice(),
      },
    );
  }
}
