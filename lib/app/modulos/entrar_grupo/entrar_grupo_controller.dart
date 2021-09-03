import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:mobiance/app/data/modelo/grupo.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/widgets/elegant_text_field.dart';
import 'package:mobiance/utils/custom_snackbar.dart';
import 'package:mobiance/utils/preferences.dart';

class   EntrarGrupoController extends GetxController {
  Grupo grupo = new Grupo();
  Firestore db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Usuario usuario;
  List listaGrupos;

  Future<void> verificarCodigo() async {
    List<String> codigos = [];

    for (Grupo itemGrupo in listaGrupos as List<Grupo>) {
      codigos.add(itemGrupo.codigo);
    }

    if (!codigos.contains(grupo.codigo)) {
      CustomSnackbar.rawSnackBar(text: 'Validando dados...', cor: corRoxa);

      FirebaseUser firebaseUser = await auth.currentUser();
      DocumentSnapshot documentSnapshot =
          await db.collection('usuarios').document(firebaseUser.uid).get();

      Map<String, dynamic> dadosUsuario = documentSnapshot.data;

      usuario = Usuario.fromJson(dadosUsuario);

      DocumentSnapshot snapshotGrupoExistente = await db
          .collection('grupos')
          .document(grupo.codigo.trim().toUpperCase())
          .get();

      if (snapshotGrupoExistente.data != null) {
        DocumentSnapshot snapshotInfoGrupo = await db
            .collection('grupos')
            .document(grupo.codigo.trim().toUpperCase())
            .collection('infoGrupo')
            .document('informacao')
            .get();
        String idAdminGrupo = snapshotInfoGrupo.data['idUsuarioAdmin'];

        if (idAdminGrupo != firebaseUser.uid) {
          grupo.nomeGrupo = snapshotInfoGrupo.data['nomeGrupo'];

          showDialog(
            barrierDismissible: false,
            context: Get.context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: Builder(builder: (context) {
                var width = MediaQuery.of(Get.context).size.width;
                return Container(
                  width: width,
                  child: ElegantTextFormField(
                    label: 'Digite seu salário',
                    keyboardType: TextInputType.number,
                    padding: EdgeInsets.only(top: 15),
                    onChange: (String valor) {
                      valor = valor.replaceAll('.', '');
                      valor = valor.replaceAll(',', '.');
                      grupo.salario = valor;
                    },
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true),
                    ],
                  ),
                );
              }),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'Voltar',
                      style: flatButtonVermelhoStyle,
                    ),
                    onPressed: () {
                      Get.back();
                    }),
                FlatButton(
                    child: Text(
                      'Confirmar',
                      style: flatButtonRoxoStyle,
                    ),
                    onPressed: () {
                      if (grupo.salario != null) {
                        salvarGrupoDocumentoUsuario();
                        salvarUsuarioGrupo();
                        Get.back();
                        Get.back();
                        Get.rawSnackbar(
                            message: "Você entrou no grupo ${grupo.nomeGrupo}!", backgroundColor: corRoxa);
                      } else {
                        Get.rawSnackbar(
                            message: 'Não deixe o campo em branco',
                            backgroundColor: corVermelha);
                      }
                    })
              ],
            ),
          );
        } else {
          Get.rawSnackbar(
              message: "Você é o Admin do grupo e já está nele",
              backgroundColor: corVermelha);
        }
      } else {
        Get.rawSnackbar(
            message: "Código inválido", backgroundColor: corVermelha);
      }
    } else {
      Get.rawSnackbar(
          message: "Você ja faz parte do Grupo ", backgroundColor: corVermelha);
    }
  }

  Future<void> salvarGrupoDocumentoUsuario() async {
    await db
        .collection('usuarios')
        .document(usuario.idUsuario)
        .collection('grupos')
        .document(grupo.codigo.trim().toUpperCase())
        .setData(grupo.toDocumentUsuarioGrupoMap());
  }

  Future<void> salvarUsuarioGrupo() async {
    print('idUuario = ' + usuario.idUsuario);
    print(grupo.toUsuarioGrupoMap(usuario));
    await db
        .collection('grupos')
        .document(grupo.codigo.trim().toUpperCase())
        .collection('usuarios')
        .document(usuario.idUsuario)
        .setData(grupo.toUsuarioGrupoMap(usuario));
  }
}
