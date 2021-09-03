import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/data/repository/login_repository.dart';
import 'package:mobiance/app/modulos/drawer/drawer_tela.dart';
import 'package:mobiance/app/modulos/finalizar_cadastro/finalizar_cadastro_tela.dart';
import 'package:mobiance/app/modulos/login/login_tela.dart';
import 'package:mobiance/utils/preferences.dart';

class BoasVindasController {
  FirebaseAuth auth = FirebaseAuth.instance;
  LoginRepository _loginRepository = LoginRepository();
  Firestore db = Firestore.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  RxBool _carregando = false.obs;

  bool get carregando => _carregando.value;

  set carregando(bool value)=> _carregando.value = value;


  Future<void> verificarUsuarioAtivo() async {
    FirebaseUser firebaseUser = await auth.currentUser();

    if (firebaseUser != null) {
      Get.rawSnackbar(
            message: "Verificando usuário logado", backgroundColor: corVerde);
      DocumentSnapshot documentSnapshot =
          await db.collection('usuarios').document(firebaseUser.uid).get();
      Usuario usuario = Usuario.fromJson(documentSnapshot.data);
      //Get.put(usuario);

      if (firebaseUser.isEmailVerified) {
        GetStorage().write('usuario', usuario);
        Get.to(usuario.dadosCompleto
            ? DrawerTela(
              )
            : FinalizarCadastro());
      } else {
        Get.to(Login());
      }
    }
  }

  Future<void> loginComGoogle() async {
    carregando = true;
    try {
      Usuario usuario = await _loginRepository.loginWithGoogle();
      GetStorage().write('usuario', usuario);
      if (usuario != null) {
        Get.to(usuario.dadosCompleto
            ? DrawerTela()
            : FinalizarCadastro());
      } else {
        Get.rawSnackbar(
            message: "Houve um erro, tente novamente",
            backgroundColor: corVermelha,
            icon: Icon(
              Icons.info_outline,
              color: corBranca,
            ));
      }
      carregando = false;
    } catch (error) {
      print(error);
    }
  }
}
