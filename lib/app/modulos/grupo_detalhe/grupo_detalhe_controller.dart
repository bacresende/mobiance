import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:mobiance/app/data/modelo/grupo.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/utils/compartilhar_codigo.dart';
import 'package:mobiance/utils/preferences.dart';

class GrupoDetalheController extends GetxController {
  Firestore db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> itensMenu = ['Compartilhar Código', 'Deletar Grupo'];
  RxList _usuarios = [].obs;

  List get usuarios => _usuarios.value;

  Grupo grupo;
  @override
  void onReady(){
    super.onReady();
    print('onReady');
    this.verificarUsuario();
    this.getUsuarios();
  }


  Future<void> getUsuarios() async {
    print(grupo.codigo);
    db
        .collection('grupos')
        .document(grupo.codigo)
        .collection('usuarios')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      _usuarios.value = querySnapshot.documents
          .map((DocumentSnapshot doc) => Grupo.fromUsuarioGrupoJson(doc.data))
          .toList();
    }); /**/
  }

  Future<void> verificarUsuario() async {
    FirebaseUser firebaseUser = await auth.currentUser();
    DocumentSnapshot snapshotUsuarioGrupo = await db
        .collection('grupos')
        .document(grupo.codigo)
        .collection('usuarios')
        .document(firebaseUser.uid)
        .get();
    bool isAdmin = snapshotUsuarioGrupo.data['isAdmin'];
    if (!isAdmin) {
      itensMenu = ['Compartilhar Código', 'Sair do Grupo'];
    }
  }

  escolhaMenuItem(String itemEscolhido) {
    print(itemEscolhido);
    switch (itemEscolhido) {
      case 'Compartilhar Código':
        share();
        break;
      case 'Deletar Grupo':
        abrirDialogDeletarGrupo();
        break;
      case 'Sair do Grupo':
        abrirDialogSairDoGrupo();
        break;
    }
  }

  void share() async {
    FirebaseUser firebaseUser = await auth.currentUser();

    DocumentSnapshot documentSnapshot =
        await db.collection('usuarios').document(firebaseUser.uid).get();
    Usuario usuario = Usuario.fromJson(documentSnapshot.data);

    CompartilhaCodigo.share(usuario: usuario, grupo: grupo);
  }

  abrirDialogDeletarGrupo() {
    return showDialog(
        barrierDismissible: false,
        context: Get.context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Text(
              "Deletar Grupo",
              style:
                  TextStyle(color: corRoxaEscura, fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Deseja realmente deletar o grupo?",
              style: TextStyle(color: corRoxa),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Não",
                  style: TextStyle(fontWeight: FontWeight.bold, color: corRoxa),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              FlatButton(
                child: Text(
                  "Sim",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: corVermelha),
                ),
                onPressed: deletarGrupo,
              ),
            ],
          );
        });
  }

  Future<void> deletarGrupo() async {
    //pegar usuarios dentro do grupo
    List<String> idUsuarios = [];
    QuerySnapshot querySnapshot = await db
        .collection('grupos')
        .document(grupo.codigo)
        .collection('usuarios')
        .getDocuments();

    for (DocumentSnapshot doc in querySnapshot.documents) {
      String idUsuario = doc.documentID;
      idUsuarios.add(idUsuario);
    }

    //excluir os grupos onde cada usuario está vinculado

    for (String idUsuario in idUsuarios) {
      await db
          .collection('usuarios')
          .document(idUsuario)
          .collection('grupos')
          .document(grupo.codigo)
          .delete();
    }

    //excluir o grupo
    await db.collection('grupos').document(grupo.codigo).delete();

    //excluir info do grupo
    await db
        .collection('grupos')
        .document(grupo.codigo)
        .collection('infoGrupo')
        .document('informacao')
        .delete();

    //excluir cada usuario da pasta de usuarios
    for (String idUsuario in idUsuarios) {
      await db
          .collection('grupos')
          .document(grupo.codigo)
          .collection('usuarios')
          .document(idUsuario)
          .delete();
    }

    Get.back();
    Get.back();
    Get.rawSnackbar(
        message: "Grupo ${grupo.nomeGrupo} excluido com sucesso!",
        backgroundColor: corRoxa);
  }

  abrirDialogSairDoGrupo() {
    return showDialog(
        barrierDismissible: false,
        context: Get.context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Text(
              "Sair do Grupo",
              style:
                  TextStyle(color: corRoxaEscura, fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Deseja realmente sair do grupo?",
              style: TextStyle(color: corRoxa),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Não",
                  style: TextStyle(fontWeight: FontWeight.bold, color: corRoxa),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              FlatButton(
                child: Text(
                  "Sim",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: corVermelha),
                ),
                onPressed: sairDoGrupo,
              ),
            ],
          );
        });
  }

  Future<void> sairDoGrupo() async {
    //excluir o grupo do document usuario
    FirebaseUser firebaseUser = await auth.currentUser();
    await db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('grupos')
        .document(grupo.codigo)
        .delete();

    //excluir o grupo
    await db
        .collection('grupos')
        .document(grupo.codigo)
        .collection('usuarios')
        .document(firebaseUser.uid)
        .delete();

    Get.back();
    Get.back();
    Get.rawSnackbar(
        message: "Você saiu do grupo ${grupo.nomeGrupo} !",
        backgroundColor: corRoxa);
  }


  Map lancamentos;

  final index = 0.obs;

  retroceder() {
    index.value++;
  }

  isFirstPage() {
    return index.value == lancamentos.length - 1;
  }

  isLastPage() {
    return index.value == 0;
  }

  lancamentoInit() {
    lancamentos = {
      'Setembro': {'25/ago': 250.5},
      'Agosto': {'25/ago': 250.5, '26/ago': 276.0, '27/ago': 290.0},
    };
  }

  getNome(int index) {
    return lancamentos.keys.elementAt(index);
  }

  Map getMap(int index) {
    Map m = lancamentos.values.elementAt(index);
    return m;
  }
}
