import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/drawer/drawer_tela.dart';

import 'package:mobiance/utils/get_usuario_atual.dart';
import 'package:mobiance/utils/icones_pessoa.dart';
import 'package:mobiance/utils/preferences.dart';

class FinalizarCadastroController extends GetxController {
  Usuario usuario = new Usuario();
  Firestore db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  File imagemSelecionada;
  RxString _iconeSelecionado = ''.obs;

  RxBool _loading = false.obs;

  bool get loading => _loading.value;

  set loading(bool value) => _loading.value = value;

  get iconeSelecionado => _iconeSelecionado.value;

  set iconeSelecionado(String value) => _iconeSelecionado.value = value;

  abrirDialogIcones() {
    List<String> iconePessoas = IconePessoas.getPessoas();
    return showDialog(
        context: Get.context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text(
                      'Selecionar Ícone',
                      style: TextStyle(
                          color: corRoxa,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: iconePessoas.length,
                    itemBuilder: (context, i) {
                      String icone = iconePessoas[i];

                      return ListTile(
                        title: Image.asset(
                          icone,
                          width: 100,
                          height: 100,
                        ),
                        onTap: () {
                          iconeSelecionado = icone;
                          usuario.imagemPerfil = icone;

                          Get.back();
                        },
                      );
                    },
                  )),
                  Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FloatingActionButton.extended(
                      backgroundColor: corBranca,
                      elevation: 0,
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: corRoxa,
                      ),
                      label: Text(
                        'Voltar',
                        style: TextStyle(
                            color: corRoxa,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future uploadImagem() async {
    FirebaseUser firebaseUser = await UsuarioAtual.getUsuarioAtual();
    //Referenciar arquivo para upload de imagens
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference pastaRaiz = firebaseStorage.ref();
    StorageReference arquivo =
        pastaRaiz.child("fotos_perfil").child("${firebaseUser.uid}.jpg");

    //Fazer upload da imagem
    if (imagemSelecionada != null) {
      StorageUploadTask task = arquivo.putFile(imagemSelecionada);

      //Controllar progesso de upload
      task.events.listen((StorageTaskEvent storageTaskEvent) {
        if (storageTaskEvent.type == StorageTaskEventType.progress) {
          //Em progresso
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
                  "Em progresso",
                  style: TextStyle(color: corRoxa),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            //duration: Duration(seconds: 2)
          );
        } else if (storageTaskEvent.type == StorageTaskEventType.success) {
          //Upload realizado com sucesso
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
                  "Upload realizado com sucesso",
                  style: TextStyle(color: corRoxa),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            //duration: Duration(seconds: 2)
          );
        }

        //Recuperar URL da imagem
        task.onComplete.then((StorageTaskSnapshot snapshot) {
          recuperarUrlImagem(snapshot);
        });
      });
    }
  }

  Future recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String urlImagem = await snapshot.ref.getDownloadURL();

    _iconeSelecionado.value = urlImagem;
    usuario.imagemPerfil = urlImagem;
  }

  void validarCampos() {
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
              "Finalizando Cadastro...",
              style: TextStyle(color: corRoxa),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        duration: Duration(seconds: 2));

    Future.delayed(Duration(seconds: 2), () {
      atualizarDados();
    });
  }

  void atualizarDados() async {
    FirebaseUser firebaseUser = await UsuarioAtual.getUsuarioAtual();
    usuario.dadosCompleto = true;
    print(firebaseUser.uid);
    db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .updateData(usuario.toJsonUpdate());

    DocumentSnapshot documentSnapshot =
        await db.collection('usuarios').document(firebaseUser.uid).get();
    Map<String, dynamic> map = documentSnapshot.data;

    Usuario usuarioCompleto = Usuario.fromJson(map);

    db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('lancamentos')
        .document('mes')
        .setData({'datas': []});
    GetStorage().write('usuario', usuarioCompleto);
    Get.offAll(DrawerTela(
    ));

    loading = false;
  }
}
