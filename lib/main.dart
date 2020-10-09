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
  String currColorName;
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
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() {
              print('tapped');

              List<String> colorNames = COLOR_MAP.keys.toList();
              currColorName = colorNames[_random.nextInt(colorNames.length)];
              currColor = COLOR_MAP[currColorName];
            }),
          child: Column(
            children: <Widget>[
              Container(
                height: 20,
                width: double.infinity,
                child: Text('$currColorName'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Tap on me',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
