import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/utils/categorias.dart';
import 'package:mobiance/utils/preferences.dart';

class GraficoPieController extends GetxController {
  RxMap data = {}.obs;
  RxInt touchedIndex = 0.obs;

  PieChartData getData(data) {
    return PieChartData(
        pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
          if (pieTouchResponse.touchInput is FlLongPressEnd ||
              pieTouchResponse.touchInput is FlPanEnd) {
            touchedIndex.value = -1;
          } else {
            touchedIndex.value = pieTouchResponse.touchedSectionIndex;
          }
        }),
        startDegreeOffset: 180,
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 5,
        centerSpaceRadius: 5,
        sections: getSections([
          Lancamento(categoria: 'Alimentos', valor: '25.0'),
          Lancamento(categoria: 'Alimentos', valor: '25.0'),
          Lancamento(categoria: 'Escola', valor: '35.0'),
          Lancamento(categoria: 'Teste', valor: '15.0'),
        ]));
  }

  List<PieChartSectionData> getSections(List<Lancamento> lancamentos) {
    Map<String, double> categorias = Map();
    double total = 0;
    for (Lancamento lancamento in lancamentos) {
      final valor = double.tryParse(lancamento.valor);
      if (valor == null) continue;
      total += valor;
      if (categorias[lancamento.categoria] != null) {
        categorias[lancamento.categoria] += valor;
      } else {
        categorias[lancamento.categoria] = valor;
      }
    }
    List<PieChartSectionData> list = List();
    double i = 0;
    int index = 0;
    for (String item in categorias.keys) {
      double opacity = index == touchedIndex.value ? 1 : 0.55;
      PieChartSectionData pieChartSectionData = PieChartSectionData(
        color: Color(0xff0293ee).withOpacity(opacity),
        value: (categorias[item] / total) * 100,
        title: item,
        radius: 60 - i,
        titleStyle: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: corBranca),
        titlePositionPercentageOffset: 0.55,
      );
      
      list.add(pieChartSectionData);
      i += 5;
      index++;
    }

    return list;

    // return List.generate(4, (i) {
    //   final isTouched = i == touchedIndex.value;
    //   final double opacity = isTouched ? 1 : 0.6;
    //   switch (i) {
    //     case 0:
    //       return PieChartSectionData(
    //         color: const Color(0xff0293ee).withOpacity(opacity),
    //         value: 25,
    //         title: 'Teste',
    //         radius: 80,
    //         titleStyle: TextStyle(
    //             fontSize: 18, fontWeight: FontWeight.bold, color: corBranca),
    //         titlePositionPercentageOffset: 0.55,
    //       );
    //     case 1:
    //       return PieChartSectionData(
    //         color: const Color(0xfff8b250).withOpacity(opacity),
    //         value: 25,
    //         title: 'Alimentos',
    //         radius: 65,
    //         titleStyle: TextStyle(
    //             fontSize: 18, fontWeight: FontWeight.bold, color: corBranca),
    //         titlePositionPercentageOffset: 0.55,
    //       );
    //     case 2:
    //       return PieChartSectionData(
    //         color: const Color(0xff845bef).withOpacity(opacity),
    //         value: 25,
    //         title: 'Escola',
    //         radius: 60,
    //         titleStyle: TextStyle(
    //             fontSize: 18, fontWeight: FontWeight.bold, color: corBranca),
    //         titlePositionPercentageOffset: 0.6,
    //       );
    //     case 3:
    //       return PieChartSectionData(
    //         color: const Color(0xff13d38e).withOpacity(opacity),
    //         value: 25,
    //         title: 'Aluguel',
    //         radius: 70,
    //         titleStyle: TextStyle(
    //             fontSize: 18, fontWeight: FontWeight.bold, color: corBranca),
    //         titlePositionPercentageOffset: 0.55,
    //       );
    //     default:
    //       return null;
    //   }
    // });
  }
}
