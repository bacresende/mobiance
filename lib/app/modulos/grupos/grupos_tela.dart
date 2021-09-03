import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/drawer/drawer_controller.dart';
import 'package:mobiance/app/modulos/drawer/widget/elegantDrawer.dart';
import 'package:mobiance/app/modulos/drawer/widget/leading_drawer.dart';
import 'package:mobiance/app/modulos/grupos/grupos_controller.dart';
import 'package:mobiance/app/modulos/grupos/widgets/grupos_botao.dart';
import 'package:mobiance/app/modulos/grupos/widgets/grupos_lista.dart';
import 'package:mobiance/utils/preferences.dart';

class Grupos extends StatelessWidget {
  final CustomDrawerController _controller = Get.find();
  final GruposController gruposController = Get.put(GruposController());
  

  final Usuario usuario = GetStorage().read('usuario') ;

  Grupos();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Grupos"),
        leading: LeadingDrawer(),
        actions: [
          Obx(() => gruposController.listaGrupos.length != 0
              ? PopupMenuButton<String>(
                  onSelected: gruposController.escolhaMenuItem,
                  itemBuilder: (context) {
                    return gruposController.itensMenu
                        .map((String item) => PopupMenuItem<String>(
                              child:
                                  Text(item, style: TextStyle(color: corRoxa)),
                              value: item,
                            ))
                        .toList();
                  },
                )
              : Container())
        ],
      ),
      drawer: ElegantDrawer(_controller.pageController),
      body: Container(
        child: Obx(() => gruposController.listaGrupos.length == 0
            ? GruposBotao()
            : GruposLista()),
      ),
    );
  }
}
