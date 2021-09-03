import 'package:flutter/material.dart';
import 'package:mobiance/utils/data_util.dart';
import 'package:mobiance/utils/preferences.dart';

class IntervaloDatas {
  static List<DropdownMenuItem<String>> getDatasIniciais(List datas) {
    List<DropdownMenuItem<String>> datasIniciais = [];

    for (String data in datas) {
      datasIniciais.add(new DropdownMenuItem(
        child: Text(DataUtil.getMostrarMesAtual(data),
            style: TextStyle(
                color: corRoxa,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        value: data,
      ));
    }

    return datasIniciais;
  }

  static List<DropdownMenuItem<String>> getDatasFinais(List datas) {
    List<DropdownMenuItem<String>> datasFinais = [];
    
    for (String data in datas) {
      datasFinais.add(new DropdownMenuItem(
        child: Text(DataUtil.getMostrarMesAtual(data),
            style: TextStyle(
                color: corRoxa,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        value: data,
      ));
    }

    return datasFinais;
  }
}
