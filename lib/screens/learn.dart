import 'package:flutter/material.dart';

class Learn  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListWheelScrollView(
        itemExtent: 70,
        children: [

          Container(
            height: 300,
            color: Colors.red,
          ),
          Container(
            height: 200,
            color: Colors.black,
          ),Container(
            height: 200,
            color: Colors.blue,
          ),Container(
            height: 200,
            color: Colors.orange,
          ),Container(
            height: 200,
            color: Colors.lightGreen,
          ),Container(
            height: 200,
            color: Colors.purple,
          ),Container(
            height: 200,
            color: Colors.pink,
          ),Container(
            height: 200,
            color: Colors.brown,
          ),
        ],),
    );
  }
}
