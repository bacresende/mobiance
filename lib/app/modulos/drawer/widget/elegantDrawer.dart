import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/widgets/perfil_image.dart';
import 'package:mobiance/utils/preferences.dart';

import 'drawerTile.dart';
import 'elegantDrawerController.dart';

class ElegantDrawer extends StatelessWidget {
  final PageController pageController;
  final Usuario usuario = GetStorage().read('usuario');
  ElegantDrawer(this.pageController);
  final ElegantDrawerController controller = Get.put(ElegantDrawerController());
  @override
  Widget build(BuildContext context) {
    Widget build() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [corRoxa, corRoxaEscura],
          )),
        );
    return Drawer(
      child: Stack(children: <Widget>[
        build(),
        ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              arrowColor: Colors.transparent,
              accountName: FutureBuilder(
                  initialData: usuario,
                  builder: (context, snapshot) {
                    Usuario usuario = snapshot.data;
                    String nome = controller.getPrimeiroNome(usuario.nome);
                    if (snapshot.hasData) {
                      return Text(
                        nome,
                        style: TextStyle(
                            color: corBranca, fontFamily: 'Pero', fontSize: 20),
                      );
                    }
                    return Container();
                  }),
              accountEmail: Text(
                '',
                style: TextStyle(color: corBranca),
              ),
              currentAccountPicture: FutureBuilder(
                  initialData: usuario,
                  builder: (context, snapshot) {
                    Usuario usuario = snapshot.data;
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        child: Image.asset(usuario.imagemPerfil),
                        radius: 60,
                        backgroundColor: corRoxa,
                      );
                    }
                    return Container();
                  }),

              //
            ),
            Divider(
              color: corBranca,
              indent: 10,
              endIndent: 10,
              thickness: 0.2,
              height: 3,
            ),
            Column(
              children: <Widget>[
                DrawerTile(
                  icon: Icons.home,
                  text: "Home",
                  controller: pageController,
                  page: 0,
                ),
                DrawerTile(
                    icon: Icons.repeat_outlined,
                    text: 'Fiados',
                    controller: pageController,
                    page: 3),
                DrawerTile(
                  icon: Icons.group,
                  text: "Grupos",
                  controller: pageController,
                  page: 1,
                ),
                /*DrawerTile(
                  icon: Icons.graphic_eq,
                  text: "Gráficos",
                  controller: pageController,
                  page: 2,
                ),*/
                DrawerTile(
                    icon: Icons.person,
                    text: 'Perfil',
                    controller: pageController,
                    page: 2),
                
                
                DrawerTile(
                  icon: Icons.info,
                  text: "Sobre Nós",
                  controller: pageController,
                  page: 4,
                  usuario: this.usuario,
                ),
                Divider(
                  color: corBranca,
                  indent: 10,
                  endIndent: 10,
                  thickness: 0.2,
                  height: 3,
                ),DrawerTile(
                  icon: Icons.help,
                  text: "Entre em Contato",
                  controller: pageController,
                  page: 5,
                  usuario: this.usuario,
                ),
                DrawerTile(
                  icon: Icons.arrow_back,
                  text: "Sair",
                  controller: pageController,
                  page: 6,
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
