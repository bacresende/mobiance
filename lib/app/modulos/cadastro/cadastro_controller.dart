import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/data/repository/login_repository.dart';
import 'package:mobiance/utils/preferences.dart';

import '../login/login_tela.dart';

class CadastroController extends GetxController {
  Usuario usuario = new Usuario();
  LoginRepository loginRepository = LoginRepository();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;

  RxBool _obscure = true.obs;
  RxBool _loading = false.obs;

  bool get obscure => _obscure.value;

  set obscure(bool value)=> _obscure.value = value;

  void setObscure() {
    obscure = !obscure;
  }

  bool get loading => _loading.value;

  set loading(bool value) => _loading.value = value;


  validarCampos() {
    loading = true;
    criarUsuario();
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
              "Criando...",
              style: TextStyle(color: corRoxa),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        duration: Duration(seconds: 2));

      
  
  }

  void criarUsuario() async {
    try{
    Usuario usuarioLocal = await loginRepository.createUserWithEmailAndPassword(
        usuario.email.trim(), usuario.senha.trim());
    print('usuario local $usuarioLocal');
    if (usuarioLocal != null) {
      onSucesso(usuario);
    } else {
      
      onFalha('Tente novamente');
    }
    }catch(error){
      onFalha(error.code);
    }
  }

  void onSucesso(Usuario usuario) {
    Get.off(Login(usuario: usuario,));
    Get.rawSnackbar(
        title: 'Usuario criado com sucesso!',
        message: 'Um e-mail de confirmação foi enviado para você',
        backgroundColor: corRoxa,
        duration: Duration(seconds: 5));
    
  }

  void onFalha(String erro) {
    loading = false;
    if(erro == 'ERROR_EMAIL_ALREADY_IN_USE'){
      Get.rawSnackbar(
        title: 'Falha ao criar usuário',
        message: 'O e-mail já está em uso',
        backgroundColor: corVermelha,
        duration: Duration(seconds: 5));
    }else{
      Get.rawSnackbar(
        title: 'Falha ao criar usuário',
        message: erro,
        backgroundColor: corVermelha,
        duration: Duration(seconds: 5));
    }
    
  }
}
