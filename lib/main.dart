import 'package:flutter/material.dart';
import 'dart:math';
import 'utils/constants.dart';


void main() => runApp(TestApp());


class TestApp extends StatelessWidget {
  final String _title = 'it\'s colors you';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: _title,
      home: ColorChange(),
    );
  }
}


class ColorChange extends StatefulWidget {
  @override
  _ColorChangeState createState() => _ColorChangeState();
}


class _ColorChangeState extends State<ColorChange> {
  Color currColor;
  int currColorValue;
  final _random = new Random();

  @override
  void initState() {
    super.initState();

    currColor = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currColor,
      body: Column(
        children: <Widget>[
          Text('${currColor.hashCode}'),
          Center(
            child: Text('Tap on me'),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() {
                print('tapped');

                currColor = COLOR_LIST[_random.nextInt(COLOR_LIST.length)];
                // currColorValue = currColor.value;
              }),

          ),
        ],
      ),
    );
  }
}

