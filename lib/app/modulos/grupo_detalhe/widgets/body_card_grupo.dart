import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mobiance/utils/preferences.dart';

class BodyCardGrupo extends StatelessWidget {
  const BodyCardGrupo({
    Key key,
    this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        child: Column(children: [
          Expanded(
              child: Card(
                  margin: EdgeInsets.fromLTRB(5, 15, 5, 0),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15))),
                  color: corBranca,
                  child: child ?? null))
        ]));
  }
}
