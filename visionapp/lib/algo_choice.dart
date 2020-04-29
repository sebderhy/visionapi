import 'package:flutter/material.dart';
import 'image_analyzer.dart';
import 'constants.dart';

class AlgoChoice extends StatelessWidget {
  static String id = 'algo_choice';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(APP_NAME),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: modelsList
                .map(
                  (e) => RaisedButton(
                    child: Text(e.name),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageAnalyzer(
                            modelPath: e.path,
                          ),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ));
  }
}
