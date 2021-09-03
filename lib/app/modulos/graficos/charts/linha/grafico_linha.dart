import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/graficos/charts/linha/grafico_linha_controller.dart';
import 'package:mobiance/utils/preferences.dart';

class GraficoLinha extends StatelessWidget {
  final GraficoLinhaController controller = Get.put(GraficoLinhaController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: <Widget>[
            AspectRatio(
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
                  child: LineChart(
                    controller.showAvg.value
                        ? controller.avgData()
                        : controller.mainData(),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 70,
              height: 34,
              child: FlatButton(
                onPressed: controller.avg,
                child: Text(
                  'média',
                  style: TextStyle(
                      fontSize: 12,
                      color: controller.showAvg.value
                          ? corBranca
                          : corBranca.withOpacity(0.5)),
                ),
              ),
            ),
          ],
        ));
  }
}
