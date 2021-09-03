import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/graficos/charts/pie/grafico_pie_controller.dart';
import 'package:mobiance/utils/preferences.dart';

class GraficoPie extends StatelessWidget {
  final GraficoPieController controller = Get.put(GraficoPieController());

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            color: corRoxa),
        child: Padding(
          padding: const EdgeInsets.only(
              right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: Obx(() => PieChart(controller.getData(controller.data))),
        ),
      ),
    );
  }
}
