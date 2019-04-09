import 'package:flutter/material.dart';

class Fast extends StatelessWidget {
  final DateTime date;

  Fast(
    this.date, {
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text(date.toString())),
      ),
    );
  }
}
