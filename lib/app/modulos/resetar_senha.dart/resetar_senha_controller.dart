import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/utils/preferences.dart';

class ResetarSenhaController extends GetxController {
  Usuario usuario = new Usuario();
  FirebaseAuth auth = FirebaseAuth.instance;

  resetarSenha() async {
    try {
      await auth.sendPasswordResetEmail(email: usuario.email.trim());

      onSucesso();
    } catch (error) {
      if (error.code == 'ERROR_USER_NOT_FOUND') {
        Get.rawSnackbar(
            message: "E-mail não existe!",
            backgroundColor: corVermelha,
            icon: Icon(
              Icons.info_outline,
              color: corBranca,
            ));
      }
    }
  }

  void onSucesso() {
    Get.rawSnackbar(
        title: 'E-mail enviado com sucesso!',
        message: 'Um e-mail de redefinição de senha foi enviado para você',
        backgroundColor: corRoxa,
        duration: Duration(seconds: 5));
    Future.delayed(Duration(seconds: 5), () {
      Get.back();
    });
  }
}
