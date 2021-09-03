import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/grupo.dart';
import 'package:mobiance/app/modulos/grupo_detalhe/grupo_detalhe_controller.dart';
import 'package:mobiance/utils/preferences.dart';

class Membros extends StatelessWidget {
  final GrupoDetalheController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              thickness: 0.5,
            ),
        itemCount: controller.usuarios.length,
        itemBuilder: (context, index) {
          Grupo grupo = controller.usuarios[index];
          return ListTile(
            title: Text(
              grupo.nomeUsuario,
              style: flatButtonRoxoStyle,
            ),
            subtitle: Text(grupo.emailUsuario),
            onTap: () {
              print(grupo.salario);
            },
          );
        });
  }
}
