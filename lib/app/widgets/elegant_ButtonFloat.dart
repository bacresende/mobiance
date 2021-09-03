import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:mobiance/utils/preferences.dart';

class ElegantButtonFloat extends StatelessWidget {
  final GlobalKey<FabCircularMenuState> fabKey;
  final Widget widgetOne;
  final Function onPressedOne;

  final Widget widgetTwo;
  final Function onPressedTwo;

  final Widget widgetThree;
  final Function onPressedThree;

  ElegantButtonFloat(
      {this.onPressedOne,
      this.onPressedTwo,
      this.onPressedThree,
      this.fabKey,
      this.widgetOne,
      this.widgetTwo,
      this.widgetThree});

  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
        ringColor: corRoxa,
        fabColor: corRoxa,
        key: this.fabKey,
        fabOpenIcon: Icon(
          Icons.add,
          color: corBranca,
        ),
        fabCloseIcon: Icon(
          Icons.close,
          color: corBranca,
        ),
        ringDiameter: 350,
        children: <Widget>[
          FlatButton(child: this.widgetOne, onPressed: this.onPressedOne),
          FlatButton(child: this.widgetTwo, onPressed: this.onPressedTwo),
          FlatButton(
            child: this.widgetThree,
            onPressed: this.onPressedThree,
          )
        ]);
  }
}
