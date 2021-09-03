import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/drawer/drawer_controller.dart';
import 'package:mobiance/app/modulos/drawer/widget/elegantDrawer.dart';
import 'package:mobiance/app/modulos/drawer/widget/leading_drawer.dart';

class Graficos extends StatelessWidget {
  final CustomDrawerController _controller = Get.find();

  final Usuario usuario = GetStorage().read('usuario');

  Graficos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gráficos"),
        leading: LeadingDrawer(),
      ),
      drawer: ElegantDrawer(_controller.pageController),
      body: Container(
        child: Text("Gráficos"),
      ),
    );
  }
}
