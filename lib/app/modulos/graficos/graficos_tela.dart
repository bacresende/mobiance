import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/drawer/drawer_controller.dart';
import 'package:mobiance/app/modulos/drawer/widget/elegantDrawer.dart';
import 'package:mobiance/app/modulos/drawer/widget/leading_drawer.dart';
import 'package:mobiance/app/modulos/graficos/charts/linha/grafico_linha.dart';
import 'package:mobiance/app/modulos/graficos/charts/pie/grafico_pie.dart';

class Graficos extends StatelessWidget {
  final CustomDrawerController _controller = Get.find();

  final Usuario usuario;

  Graficos({this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gráficos"),
        leading: LeadingDrawer(),
      ),
      drawer: ElegantDrawer(_controller.pageController),
      body: SingleChildScrollView(
        child: Column(
          children: [GraficoLinha(), GraficoPie()],
        ),
      ),
    );
  }
}
