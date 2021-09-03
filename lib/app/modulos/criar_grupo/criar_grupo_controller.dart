import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/grupo.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/utils/compartilhar_codigo.dart';
import 'package:mobiance/utils/preferences.dart';

class CriarGrupoController extends GetxController {
  Grupo grupo = new Grupo(isAdmin: true);
  Usuario usuario;
  Firestore db = Firestore.instance;
  RxBool _grupoCriado = false.obs;

  bool get grupoCriado => _grupoCriado.value;

  set grupoCriado(bool valor) => _grupoCriado.value = valor;

  Future<void> criarGrupo() async {
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
              "Criando grupo",
              style: TextStyle(color: corRoxa),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        duration: Duration(seconds: 2));
    await setUsuario();
    await gerarCodigo();
  }

  Future<void> gerarCodigo() async {
    
    if (usuario != null) {
      QuerySnapshot querySnapshot =
          await db.collection("grupos").getDocuments();
      String codigoGerado = '';
      List<String> listaCupom = [];
      Random random = new Random();

      //Lista que terá todas as letras do alfabeto
      List<String> listaAlfabeto = lista();

      for (int i = 0; i < 3; i++) {
        int indexRandomico = random.nextInt(listaAlfabeto.length);
        codigoGerado += listaAlfabeto[indexRandomico];

        String digitoNumRandomico = random.nextInt(10).toString();
        codigoGerado += digitoNumRandomico;
      }

      List<String> listaCodigo = codigoGerado.split('');
      listaCodigo.shuffle();

      for (String letra in listaCodigo) {
        grupo.codigo += letra;
      }

      for (var item in querySnapshot.documents) {
        String codigo = item.documentID;

        listaCupom.add(codigo);
      }

      if (listaCupom.contains(grupo.codigo)) {
        await gerarCodigo();
      } else {
        await salvarInfoGrupo();
        await salvarDadosUsuarioNoGrupo();
        await salvarGrupoNoDocumentUsuario();
        Future.delayed(Duration(seconds: 2), () {
          onSucesso();
          grupoCriado = true;
        });
      }
    } else {
      Get.rawSnackbar(
          message: 'Houve um problema com a internet, tente novamente',
          backgroundColor: corVermelha);
    }
  }

  Future<void> setUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();

    DocumentSnapshot documentSnapshot =
        await db.collection('usuarios').document(firebaseUser.uid).get();

    Map<String, dynamic> dadosUsuario = documentSnapshot.data;

    usuario = Usuario.fromJson(dadosUsuario);
  }

  Future<void> salvarInfoGrupo() async {
    await db
        .collection("grupos")
        .document(grupo.codigo)
        .collection('infoGrupo')
        .document('informacao')
        .setData(grupo.toInfoGrupoMap(usuario));

    await salvarCodigoGrupo();
  }

  Future<void> salvarCodigoGrupo() async {
    await db
        .collection("grupos")
        .document(grupo.codigo)
        .setData({'codigo': grupo.codigo});
  }

  Future<void> salvarDadosUsuarioNoGrupo() async {
    await db
        .collection("grupos")
        .document(grupo.codigo)
        .collection('usuarios')
        .document(usuario.idUsuario)
        .setData(grupo.toUsuarioGrupoMap(usuario));
  }

  Future<void> salvarGrupoNoDocumentUsuario() async {
    print('idUsuario ' + usuario.idUsuario);
    print(grupo.toDocumentUsuarioGrupoMap());
    await db
        .collection('usuarios')
        .document(usuario.idUsuario)
        .collection('grupos')
        .document(grupo.codigo)
        .setData(grupo.toDocumentUsuarioGrupoMap());
  }

  List<String> lista() {
    return [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'Y',
      'X',
      'W',
      'Z'
    ];
  }

  void onSucesso() {
    Get.rawSnackbar(
        title: 'Grupo "${grupo.nomeGrupo}" criado com sucesso!',
        message:
            'Compartilhe o código de acesso "${grupo.codigo}" para as pessoas desejadas',
        backgroundColor: corRoxa,
        duration: Duration(seconds: 5));
  }

  void share() async {
    CompartilhaCodigo.share(usuario: usuario, grupo: grupo);
  }
}
