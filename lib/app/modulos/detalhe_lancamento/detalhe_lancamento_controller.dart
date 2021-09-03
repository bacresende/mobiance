import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/despesa/despesa_tela.dart';
import 'package:mobiance/app/modulos/drawer/drawer_tela.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/app/modulos/receita/receita_tela.dart';
import 'package:mobiance/app/widgets/elegant_dialog.dart';
import 'package:mobiance/utils/data_util.dart';
import 'package:mobiance/utils/get_usuario_atual.dart';
import 'package:mobiance/utils/preferences.dart';

class DetalheLancamentoController extends GetxController {
  Lancamento lancamento;
  Usuario usuario;
  List<String> itensMenu = ['Editar', 'Excluir Lançamento'];
  Firestore db = Firestore.instance;

  List<Container> getListaImagens() {
    return lancamento.fotos
        .map((String url) => Container(
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(url), fit: BoxFit.fitWidth)),
            ))
        .toList();
  }

  escolhaMenuItem(String itemEscolhido) {
    print(itemEscolhido);
    switch (itemEscolhido) {
      case 'Editar':
        editar();
        break;
      case 'Excluir Lançamento':
        dialogExclusao();
        break;
    }
  }

  void editar() {
    lancamento.tipo == 'd' ? Get.to(DespesaTela(lancamentoEdicao: lancamento, usuario: usuario,)) : Get.to(ReceitaTela(lancamentoEdicao: lancamento, usuario: usuario,));
  }

  void dialogExclusao() {

    showDialog(
        context: Get.context,
        builder: (context) {
          return ElegantDialog(
            corDeFundo: corVermelha,
            titulo: "Excluir Lançamento",
            descricao: "Deseja excluir ${lancamento.titulo} ?",
            icone: Icons.delete,
            primeiroBotao: FlatButton(
              child: Text(
                'Não',
                style: dialogFlatButtonRoxoStyle,
              ),
              onPressed: () async {
                Get.back();
                },
            ),
            segundoBotao: FlatButton(
              child: Text(
                'Sim',
                style: dialogFlatButtonVermelhoStyle,
              ),
              onPressed: excluirLancamento,
            ),
          );
        });
  }

  void excluirLancamento() async {
    FirebaseUser firebaseUser = await UsuarioAtual.getUsuarioAtual();
    //excluir fotos (Se tiver)
    if (lancamento.fotos.isNotEmpty) {
      excluirImagensDoStorage(firebaseUser);
    }
    //excluir lancamento
    excluirLancamentoDoFirestore(firebaseUser);

    //verificar exclusão de um item da lista de datas no document de mes
    verificarItemDaLista(firebaseUser);
    Future.delayed(Duration(seconds: 2), () {
      onSucesso('Exclusão realizada com sucesso!');
    });
  }

  void excluirImagensDoStorage(FirebaseUser firebaseUser) async{
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference pastaRaiz = firebaseStorage.ref();
    for (String nomeFoto in lancamento.nomeFotos) {
      StorageReference arquivo = pastaRaiz
          .child("fotos_lancamentos")
          .child(firebaseUser.uid)
          .child(lancamento.idLancamento)
          .child('$nomeFoto.jpg');
      await arquivo.delete();
    }
  }

  void excluirLancamentoDoFirestore(FirebaseUser firebaseUser) {
    if (lancamento.parcelado) {
      for (String dataDespesa in lancamento.datasDespesasParceladas) {
        db
            .collection('usuarios')
            .document(firebaseUser.uid)
            .collection('lancamentos')
            .document('mes')
            .collection(dataDespesa)
            .document(lancamento.idLancamento)
            .delete();
      }
    } else {
      String dataLancamento = DataUtil.getAnoMes(lancamento.data);
      db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .collection(dataLancamento)
          .document(lancamento.idLancamento)
          .delete();
    }
  }

  Future<void> verificarItemDaLista(FirebaseUser firebaseUser) async {
    DocumentSnapshot documentSnapshotDatas = await db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('lancamentos')
        .document('mes')
        .get();

    List<String> datas = List<String>.from(documentSnapshotDatas.data['datas']);

    if (lancamento.parcelado) {
      for (String dataDespesa in lancamento.datasDespesasParceladas) {
        QuerySnapshot querySnapshotLancamento = await db
            .collection('usuarios')
            .document(firebaseUser.uid)
            .collection('lancamentos')
            .document('mes')
            .collection(dataDespesa)
            .getDocuments();

        print('documentSnapshotLancamento $querySnapshotLancamento ');

        if (querySnapshotLancamento.documents.isEmpty) {
          datas.remove(dataDespesa);
        }
      }
    } else {
      String dataLancamento = DataUtil.getAnoMes(lancamento.data);

      QuerySnapshot querySnapshotLancamento = await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .collection(dataLancamento)
          .getDocuments();


      if (querySnapshotLancamento.documents.isEmpty) {
        datas.remove(dataLancamento);
      }
    }

    if (datas.isNotEmpty) {
      await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .setData({'datas': datas});
    } else {
      await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .setData({'datas': []});
    }
  }

  void onSucesso(String texto) {
    Get.delete<HomeController>();
    GetStorage().write('usuario', usuario) ;
    Get.offAll(DrawerTela());
    Get.rawSnackbar(
      message: texto,
      backgroundColor: corRoxa,
    );
  }
}
