import 'package:flutter/material.dart';


class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Something went wrong'),
        ),
      ),
    );
  }
}
