import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/data/repository/login_repository.dart';

import 'package:mobiance/utils/preferences.dart';

import '../../../utils/preferences.dart';

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  LoginRepository loginRepository = new LoginRepository();
  Firestore db = Firestore.instance;
  Usuario usuario = new Usuario();

  RxBool _obscure = true.obs;

  RxBool _loading = false.obs;

  bool get obscure => _obscure.value;

  set obscure(bool value) => _obscure.value = value;

  void setObscure() {
    obscure = !obscure;
  }

  bool get loading => _loading.value;

  set loading(bool value) => _loading.value = value;

  void setUsuario(Usuario usuario){
    if(usuario != null){
      this.usuario = usuario;
    }
  }

  void reenviarCodigo() async {
    FirebaseUser firebaseUser = await auth.currentUser();
    if (firebaseUser != null) {
      firebaseUser.sendEmailVerification();
      Get.rawSnackbar(
          title: 'Email de Verificação Reenviado!',
          message: 'Um e-mail de confirmação foi reenviado para você',
          backgroundColor: corRoxa,
          duration: Duration(seconds: 5));
    } else {
      
      Get.rawSnackbar(
          title: 'Usuário não encontrado!',
          message: 'Falha ao obter usuário.',
          backgroundColor: corVermelha,
          duration: Duration(seconds: 5));
    }
  }

  validarCampos() {
    loading = true;
    Get.rawSnackbar(
        messageText: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
            SizedBox(width: 15),
            Text(
              "Entrando...",
              style: TextStyle(color: corRoxa),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        duration: Duration(seconds: 2));

    Future.delayed(Duration(seconds: 2), () {
      logarUsuario();
    });
  }

  void logarUsuario() async {
    try{
      await loginRepository.signInWithEmailAndPassword(
        usuario.email.trim(), usuario.senha.trim());
    }catch(error){
      print('erro aqui ${error.code}');
      
    }
    loading = false;
  }
}
