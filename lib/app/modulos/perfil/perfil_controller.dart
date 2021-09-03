import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/drawer/drawer_tela.dart';
import 'package:mobiance/utils/get_usuario_atual.dart';
import 'package:mobiance/utils/icones_pessoa.dart';
import 'package:mobiance/utils/perfil_utils.dart';
import 'package:mobiance/utils/preferences.dart';

class PerfilEditarController extends GetxController {
  Firestore db = Firestore.instance;
  Usuario usuario;
  Usuario usuarioClone = Usuario();
  RxString _iconeSelecionado = ''.obs;

  String get iconeSelecionado => _iconeSelecionado.value;

  set iconeSelecionado(String value) => _iconeSelecionado.value = value;

  clonarUsuario(Usuario usuario) {
    this.usuario = usuario.novoUsuario();
    usuarioClone = PerfilUtils.cloneToEdit(this.usuario);
  }

  setIcone() {
    iconeSelecionado = usuarioClone.imagemPerfil;
  }

  salvarAlteracao() {
    PerfilUtils.undoEditedClone(usuario, usuarioClone);
    atualizarDados();
  }

  abrirDialog(BuildContext context) {}

  void atualizarDados() async {
    FirebaseUser firebaseUser = await UsuarioAtual.getUsuarioAtual();
    db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .updateData(this.usuario.toJsonEditar());
    print('usuario editado ${this.usuario}');

    //GetStorage funcionando 100% sem precisar fazer consulta ao banco de dados, o código da consulta
    //ainda está aqui para se caso ocorrer algum erro futuro, basta descomentarmos

    /*DocumentSnapshot documentSnapshot =
        await db.collection('usuarios').document(firebaseUser.uid).get();
    Map<String, dynamic> map = documentSnapshot.data;
    Usuario usuario = Usuario.fromJson(map);*/

    GetStorage().write('usuario', this.usuario);
    Get.offAll(DrawerTela());
  }

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
                          usuarioClone.imagemPerfil = icone;

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
}
