import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';


class ElegantAppBar {
  ElegantAppBar();

  static elegantAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          }),
    );
  }
}
