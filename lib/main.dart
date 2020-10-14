import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/constants.dart';


void main() async {
  final prefs = await SharedPreferences.getInstance();
  runApp(TestApp(prefs));
}


class TestApp extends StatelessWidget {
  SharedPreferences prefs;
  final String _title = "it's colors you";

  TestApp(SharedPreferences prefs) {
    this.prefs = prefs;
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: _title,
      home: ColorChange(prefs),
    );
  }
}

class ColorChange extends StatefulWidget {
  SharedPreferences prefs;

  ColorChange(SharedPreferences prefs) {
    this.prefs = prefs;
  }
  @override
  _ColorChangeState createState() => _ColorChangeState(prefs);
}


class _ColorChangeState extends State<ColorChange> {
  SharedPreferences prefs;
  final _random = new Random();
  Color currColor;
  String currColorName;
  TextAlign nameAlignment; // TextAlign.left or TextAlign.right
  bool isNameOnTop;

  _ColorChangeState(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  @override
  void initState() {
    super.initState();

    isNameOnTop = true;
    nameAlignment = TextAlign.left;
  }


  void saveColor(int r, int g, int b, double opacity) {
    prefs.setInt('r', r);
    prefs.setInt('g', g);
    prefs.setInt('b', b);
    prefs.setDouble('opacity', opacity);
  }

  Future<dynamic> getColorInfo() async {
    final int r = prefs.getInt('r');
    final int g = prefs.getInt('g');
    final int b = prefs.getInt('b');
    final double opacity = prefs.getDouble('opacity');
    List<dynamic> colorInfo = [r, g, b, opacity];

    if (colorInfo.any((info) => info == null)) {
      return initColor;
    }
    return colorInfo;
  }

  List<dynamic> getRandRGBO() {
    final int r = _random.nextInt(rgbConst);
    final int g = _random.nextInt(rgbConst);
    final int b = _random.nextInt(rgbConst);
    final double opacity = _random.nextDouble()*(1.0-0.25) + 0.25;
    List<dynamic> colorInfo = [r, g, b, double.parse(opacity.toStringAsFixed(2))];

    saveColor(colorInfo[0],colorInfo[1],colorInfo[2],colorInfo[3]);
    return colorInfo;
  }

  void setColorVars(List<dynamic> colorInfo) {
    currColor = Color.fromRGBO(colorInfo[0],colorInfo[1],colorInfo[2],colorInfo[3]);
    currColorName = 'RGBO($colorInfo)';
  }

  void setAlignParams(double dx, double dy) {
    if ((dx > 0) & (dy < 0)) {
      nameAlignment = TextAlign.right;
      isNameOnTop = true;
    } else if ((dx > 0) & (dy > 0)) {
      nameAlignment = TextAlign.right;
      isNameOnTop = false;
    } else if ((dx < 0) & (dy < 0)) {
      nameAlignment = TextAlign.left;
      isNameOnTop = true;
    } else if ((dx < 0) & (dy > 0)) {
      nameAlignment = TextAlign.left;
      isNameOnTop = false;
    }
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
    if (isNameOnTop == true) {
      return <Widget>[colorNameCont, mainExpanded];
    } else {
      return <Widget>[mainExpanded, colorNameCont];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getColorInfo(),
      initialData: initColor,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<dynamic> data = snapshot.hasData ? snapshot.data : initColor;
        setColorVars(data);
        return _buildWidget();
    });
  }

  Widget _buildWidget() {
    return new Scaffold(
      backgroundColor: currColor,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) => setState(() {
            print('swapped');

            setAlignParams(details.delta.dx, details.delta.dy);
          }),
          onTap: () => setState(() {
            print('tapped');

            List<dynamic> colorInfo = getRandRGBO();
            currColor = Color.fromRGBO(colorInfo[0],colorInfo[1],colorInfo[2],colorInfo[3]);
            currColorName = 'RGBO($colorInfo)';
          }),
          child: Column(
            children: getWidgetList(isNameOnTop),
          ),
        ),
      ),
    );
  }
}
