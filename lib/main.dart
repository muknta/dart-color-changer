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
  TextAlign nameAlignment; // TextAlign.left or TextAlign.right
  bool isNameOnTop;
  final _random = new Random();

  @override
  void initState() {
    super.initState();

    isNameOnTop = true;
    nameAlignment = TextAlign.left;
    currColor = Colors.white;
    currColorName = 'white';
  }


  Container getColorNameCont(String colorName, TextAlign alignm) {
    return Container(
              height: 30,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Text(
                  'pull to the corner $colorName',
                  textAlign: alignm,
                ),
              ),
            );
  }

  Expanded getMainExpanded() {
    return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom:40.0),
                child: Container(
                  child: Center(
                    child: Text(
                      'Tap on me',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ),
            );
  }

  // too poorly, I know :)
  List<Widget> getWidgetList(isNameOnTop) {
    Expanded mainExpanded = getMainExpanded();
    Container colorNameCont = getColorNameCont(currColorName, nameAlignment);
    if (isNameOnTop != true) {
      return <Widget>[colorNameCont, mainExpanded];
    } else {
      return <Widget>[mainExpanded, colorNameCont];
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currColor,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) => setState(() {
            print('swapped');

            double dx = details.delta.dx;
            double dy = details.delta.dy;
            if ((dx > 0) & (dy > 0)) {
              nameAlignment = TextAlign.right;
              isNameOnTop = true;
            } else if ((dx > 0) & (dy < 0)) {
              nameAlignment = TextAlign.right;
              isNameOnTop = false;
            } else if ((dx < 0) & (dy > 0)) {
              nameAlignment = TextAlign.left;
              isNameOnTop = true;
            } else if ((dx < 0) & (dy < 0)) {
              nameAlignment = TextAlign.left;
              isNameOnTop = false;
            }
          }),
          onTap: () => setState(() {
            print('tapped');

            List<String> colorNames = COLOR_MAP.keys.toList();
            currColorName = colorNames[_random.nextInt(colorNames.length)];
            currColor = COLOR_MAP[currColorName];
          }),
          child: Column(
            children: getWidgetList(isNameOnTop),
          ),
        ),
      ),
    );
  }
}
