import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class CustomDrawerController extends GetxController {
  final pageController = PageController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  toolipDrawer(BuildContext context) {
    MaterialLocalizations.of(context).openAppDrawerTooltip;
  }
}
