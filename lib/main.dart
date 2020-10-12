import 'package:flutter/material.dart';
import 'dart:math';
/// first version
import 'utils/constants.dart';
/// second version
import 'package:shared_preferences/shared_preferences.dart';

/*
* first version
* with predefined map of colors in 'constants.dart'
* 
* second version
* with fully random colors by RGBO scheme
* and via shared_preferences
*/

void main() => runApp(TestApp());


class TestApp extends StatelessWidget {
  final String _title = "it's colors you";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: _title,
      home: ColorChange(),
    );
  }
}

/// second version part-realisation start
class ColorChange extends StatefulWidget {
  @override
  _ColorChangeState createState() => _ColorChangeState();
}


void saveColor(int r, int g, int b, double opacity) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('r', r);
  prefs.setInt('g', g);
  prefs.setInt('b', b);
  prefs.setDouble('opacity', opacity);
}

Future<dynamic> getColorInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final int r = prefs.getInt('r');
  final int g = prefs.getInt('g');
  final int b = prefs.getInt('b');
  final double opacity = prefs.getDouble('opacity');
  List<dynamic> colorInfo = [r, g, b, opacity];
  if (colorInfo.any((info) => info == null)) {
    return [255,255,255,1.00];
  }
  return colorInfo;
}

List<dynamic> getRandRGBO() {
  const rgbConst = 256;
  final _random = new Random();
  final int r = _random.nextInt(rgbConst);
  final int g = _random.nextInt(rgbConst);
  final int b = _random.nextInt(rgbConst);
  final double opacity = _random.nextDouble()*(1.0-0.25) + 0.25;
  List<dynamic> colorInfo = [r, g, b, double.parse(opacity.toStringAsFixed(2))];
  // saveColor(*colorInfo);
  saveColor(colorInfo[0],colorInfo[1],colorInfo[2],colorInfo[3]);
  return colorInfo;
}
/// second version part-realisation end


class _ColorChangeState extends State<ColorChange> {
  Color currColor;
  String currColorName;
  TextAlign nameAlignment; // TextAlign.left or TextAlign.right
  bool isNameOnTop;
  /// for first version
  // final _random = new Random();

  @override
  void initState() {
    super.initState();

    // List<dynamic> colorInfo;
    isNameOnTop = true;
    nameAlignment = TextAlign.left;
    /// first version
    // currColor = Colors.white;
    // currColorName = 'white';
    /// second version
    // List<dynamic> colorInfo = await getColorInfo(); // ?? [255,255,255,1.00];
    List<dynamic> colorInfo = [255,255,255,1.00];

    // getColorInfo.whenComplete((result) {
    //   setState(() {colorInfo = result;});
    // });

    // almost working ^^
    // _asyncMethod() async {
    //           colorInfo = await getColorInfo();
    //       }
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //         _asyncMethod();
    //       });


    // currColor = Color.fromRGBO(*colorInfo);
    currColor = Color.fromRGBO(colorInfo[0],colorInfo[1],colorInfo[2],colorInfo[3]);
    currColorName = 'RGBO($colorInfo)';
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

            /// first version
            // List<String> colorNames = COLOR_MAP.keys.toList();
            // currColorName = colorNames[_random.nextInt(colorNames.length)];
            // currColor = COLOR_MAP[currColorName];
            /// second version
            List<dynamic> colorInfo = getRandRGBO();
            // currColor = Color.fromRGBO(*colorInfo);
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
