import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/criar_grupo/criar_grupo_tela.dart';
import 'package:mobiance/app/modulos/entrar_grupo/entrar_grupo_tela.dart';
import 'package:mobiance/app/modulos/grupos/grupos_controller.dart';
import 'package:mobiance/utils/preferences.dart';

class GruposBotao extends StatelessWidget {
  final GruposController gruposController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: Obx(
          () => FlatButton(
              highlightColor: corRoxa,
              onHighlightChanged: gruposController.setClicadoCriarGrupo,
              child: Text(
                'Criar um Grupo',
                style: gruposController.clicadoCriargrupo
                    ? flatButtonBrancoStyle
                    : flatButtonRoxoStyle,
              ),
              onPressed: () {
                Get.to(CriarGrupo());
              }),
        )),
        Divider(
          thickness: 0.5,
          color: corRoxaEscura,
        ),
        Expanded(
            child: Obx(
          () => FlatButton(
              highlightColor: corRoxa,
              onHighlightChanged: gruposController.setClicadoEntrarGrupo,
              child: Text(
                'Entrar em um Grupo',
                style: gruposController.clicadoEntrarGrupo
                    ? flatButtonBrancoStyle
                    : flatButtonRoxoStyle,
              ),
              onPressed: () {
                Get.to(EntrarGrupo(gruposController.listaGrupos));
              }),
        ))
      ],
    ));
  }
}
