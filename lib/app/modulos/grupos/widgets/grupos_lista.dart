import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/grupo.dart';
import 'package:mobiance/app/modulos/grupo_detalhe/grupo_detalhe_tela.dart';
import 'package:mobiance/app/modulos/grupos/grupos_controller.dart';
import 'package:mobiance/utils/preferences.dart';

class GruposLista extends StatelessWidget {
  final GruposController gruposController = Get.find();
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(thickness: 0.5,),
        itemCount: gruposController.listaGrupos.length,
        itemBuilder: (context, index) {
          Grupo grupo = gruposController.listaGrupos[index];
          return ListTile(
            title: Text(grupo.nomeGrupo, style:flatButtonRoxoStyle ,),
            subtitle: Text(grupo.codigo),
            onTap: (){
              Get.to(GrupoDetalhe(grupo));
            },
          );
        });
  }
}
