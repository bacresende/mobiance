import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiance/app/modulos/splash_screen/splash_screen.dart';

import 'utils/preferences.dart';

void main() async {
  await GetStorage.init();
  runApp(GetMaterialApp(
    title: 'Mobiance',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: corRoxa,
      accentColor: corRoxaEscura,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: SplashTela(),
  ));
}
