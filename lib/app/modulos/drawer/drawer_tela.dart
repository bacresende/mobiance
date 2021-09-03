import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/drawer/drawer_controller.dart';
import 'package:mobiance/app/modulos/fiados/fiados_controller.dart';
import 'package:mobiance/app/modulos/fiados/fiados_tela.dart';
import 'package:mobiance/app/modulos/grupos/grupos_tela.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/app/modulos/home/home_tela.dart';
import 'package:mobiance/app/modulos/perfil/perfil_visualizar_tela.dart';
import 'package:mobiance/app/modulos/sobre_nos/sobre_nos_tela.dart';

class DrawerTela extends StatelessWidget {
  final CustomDrawerController _controller = Get.put(CustomDrawerController());
  final HomeController homeController = Get.put(HomeController(), permanent: true);
  final FiadosController fiadosController = Get.put(FiadosController(), permanent: true);



  DrawerTela();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller.pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Home(),
        Grupos(),
        //Graficos(),
        PerfilVisualizar(),
        Fiados(),
        SobreNos()
      ],
    );
  }
}
