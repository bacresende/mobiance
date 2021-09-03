import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/grupo.dart';
import 'package:mobiance/app/modulos/grupo_detalhe/grupo_detalhe_controller.dart';
import 'package:mobiance/app/modulos/grupo_detalhe/widgets/lancamentos.dart';
import 'package:mobiance/app/modulos/grupo_detalhe/widgets/membros.dart';
import 'package:mobiance/app/widgets/elegant_ButtonFloat.dart';
import 'package:mobiance/utils/preferences.dart';

class GrupoDetalhe extends StatelessWidget {
  final Grupo grupo;
  final GrupoDetalheController controller = Get.put(GrupoDetalheController());
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  GrupoDetalhe(this.grupo);
  @override
  Widget build(BuildContext context) {
    controller.grupo = this.grupo;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Get.delete<GrupoDetalheController>();
                Get.back();
              }),
          title: Text(grupo.nomeGrupo),
          bottom: TabBar(
            indicatorColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Lançamentos',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  'Membros',
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: controller.escolhaMenuItem,
              itemBuilder: (context) {
                return controller.itensMenu
                    .map((String item) => PopupMenuItem<String>(
                          child: Text(
                            item,
                            style: TextStyle(color: corRoxa),
                          ),
                          value: item,
                        ))
                    .toList();
              },
            )
          ],
        ),
        body: TabBarView(
          children: [
            Lancamentos(),
            Obx(() => controller.usuarios.length > 0
                ? Membros()
                : Center(
                    child: CircularProgressIndicator(),
                  ))
          ],
        ),
        floatingActionButton: ElegantButtonFloat(
          fabKey: fabKey,
          widgetOne: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info, color: corBranca),
              Text(
                'Info',
                style: TextStyle(color: corBranca),
              )
            ],
          ),
          onPressedOne: () {},
          widgetTwo: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.monetization_on, color: corBranca),
              Text(
                'Receita',
                style: TextStyle(color: corBranca),
              )
            ],
          ),
          onPressedTwo: () {},
          widgetThree: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.monetization_on), Text('Despesa')],
          ),
        ),
      ),
    );
  }
}
