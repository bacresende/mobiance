import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobiance/utils/preferences.dart';

class InfoFeatureSnackbar {
  static void snackbar(String mensagem) {
    Get.rawSnackbar(
        duration: Duration(seconds: 5),
        message: 'Estamos trabalhando para inserir o "' +
            mensagem +
            '" o mais breve possível!',
        backgroundColor: corVerde,
        icon: Icon(
          Icons.info_outline,
          color: corBranca,
        ));
  }
}
