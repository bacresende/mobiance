import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobiance/app/modulos/drawer/drawer_tela.dart';
import 'package:mobiance/app/modulos/finalizar_cadastro/finalizar_cadastro_tela.dart';
import 'package:mobiance/utils/preferences.dart';

class LoginApiClient {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Firestore _db = Firestore.instance;
  LoginApiClient();

  Future<Usuario> createUserWithEmailAndPassword(
      String email, String senha) async {
    Usuario usuario = new Usuario();
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      FirebaseUser firebaseUser = authResult.user;

      firebaseUser.sendEmailVerification();
      usuario.email = email;
      usuario.idUsuario = firebaseUser.uid;
      usuario.dadosCompleto = false;
      _db
          .collection('usuarios')
          .document(usuario.idUsuario)
          .setData(usuario.toJson());

      return usuario;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String senha) async {
    try {
      AuthResult authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);

      if (authResult.user.isEmailVerified) {
        DocumentSnapshot snapshot = await _db
            .collection('usuarios')
            .document(authResult.user.uid)
            .get();
        //Usuario usuario = Get.put(Usuario.fromJson(map));
        Usuario usuario = Usuario.fromJson(snapshot.data);

        if (usuario.dadosCompleto) {
          GetStorage().write('usuario', usuario);
          //Cadastro ok
          Get.offAll(DrawerTela(
          ));
        } else {
          //Finalizar Cadastro
          Get.to(FinalizarCadastro());
        }
      } else {
        Get.rawSnackbar(
            message: "E-mail não verificado!", backgroundColor: corVermelha);
      }
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          Get.rawSnackbar(
              message: "E-mail inválido!",
              backgroundColor: corVermelha,
              icon: Icon(
                Icons.info_outline,
                color: corBranca,
              ));
          break;
        case "ERROR_WRONG_PASSWORD":
          Get.rawSnackbar(
              message: "Senha incorreta!",
              backgroundColor: corVermelha,
              icon: Icon(
                Icons.info_outline,
                color: corBranca,
              ));

          break;
        case "ERROR_USER_NOT_FOUND":
          Get.rawSnackbar(
              message: "E-mail não existe!",
              backgroundColor: corVermelha,
              icon: Icon(
                Icons.info_outline,
                color: corBranca,
              ));

          break;
        case "ERROR_USER_DISABLED":
          Get.rawSnackbar(
              message: "Conta desativada!",
              backgroundColor: corVermelha,
              icon: Icon(
                Icons.info_outline,
                color: corBranca,
              ));

          break;
        case "ERROR_TOO_MANY_REQUESTS":
          Get.rawSnackbar(
              message: "Muitas requisições, tente novamente mais tarde!",
              backgroundColor: corVermelha,
              icon: Icon(
                Icons.info_outline,
                color: corBranca,
              ));

          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          Get.rawSnackbar(
              message: "Login indisponível!",
              backgroundColor: corVermelha,
              icon: Icon(
                Icons.info_outline,
                color: corBranca,
              ));

          break;
        default:
          Get.rawSnackbar(
              message: "Ocorreu um erro, tente novamente mais tarde!",
              backgroundColor: corVermelha,
              icon: Icon(
                Icons.info_outline,
                color: corBranca,
              ));
      }
      // if (errorMessage != null) {
      // return Future.error(errorMessage);
    }
  }

  Future<Usuario> loginWithGoogle() async {
    Usuario usuarioLocal = Usuario();
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;

      DocumentSnapshot documentSnapshot =
          await _db.collection('usuarios').document(user.uid).get();

      if (documentSnapshot.data == null) {
        usuarioLocal.email = user.email;
        usuarioLocal.dadosCompleto = false;
        usuarioLocal.idUsuario = user.uid;

        await _db
            .collection('usuarios')
            .document(usuarioLocal.idUsuario)
            .setData(usuarioLocal.toJson());
      } else {
        usuarioLocal = Usuario.fromJson(documentSnapshot.data);
      }
      print('Usuario do google sign_in $usuarioLocal');
      
      return usuarioLocal;
    } catch (error) {
      if (error.code == 'sign_in_canceled') {
        Get.rawSnackbar(
            message: "Houve um erro, tente novamente",
            backgroundColor: corVermelha,
            icon: Icon(
              Icons.info_outline,
              color: corBranca,
            ));
      }
      return null;
    }
  }
}
