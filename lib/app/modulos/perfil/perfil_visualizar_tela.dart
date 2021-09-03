import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/drawer/drawer_controller.dart';
import 'package:mobiance/app/modulos/drawer/widget/elegantDrawer.dart';
import 'package:mobiance/app/modulos/drawer/widget/leading_drawer.dart';
import 'package:mobiance/app/modulos/perfil/perfil_controller.dart';
import 'package:mobiance/app/modulos/perfil/perfil_editar_tela.dart';
import 'package:mobiance/app/widgets/info_card.dart';
import 'package:mobiance/app/widgets/perfil_image.dart';
import 'package:mobiance/utils/perfil_utils.dart';
import 'package:mobiance/utils/preferences.dart';

class PerfilVisualizar extends StatelessWidget {
  final CustomDrawerController _controller = Get.find();
  //final Usuario usuario = Get.find();

  final Usuario usuario = GetStorage().read('usuario') ;

  PerfilVisualizar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corBranca,
      drawer: ElegantDrawer(_controller.pageController),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool scroll) => <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(15))),
                    expandedHeight: 250,
                    floating: false,
                    pinned: true,
                    leading: LeadingDrawer(),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(PerfilUtils.getPrimeiroNome(usuario.nome)),
                      centerTitle: true,
                      background: Center(
                        child: PerfilIcon(
                          imagemPerfil: usuario.imagemPerfil,
                          radius: 80.0,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => Get.to(PerfilEditar(usuario: usuario)))
                    ],
                  ),
                ),
              ],
          body: Builder(builder: (BuildContext context) {
            return CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Column(
                      children: [
                        Divider(),
                        InfoCard(text: usuario.nome, info: 'Nome', icon: Icons.person_rounded,),
                        InfoCard(text: PerfilUtils.mascaraCpf(usuario.cpf), info: 'CPF', icon: Icons.chrome_reader_mode,),
                        InfoCard(text: usuario.dataNascimento, info: 'Nascimento', icon: Icons.calendar_today_outlined,),
                        InfoCard(text: usuario.email, info: 'E-mail', icon: Icons.email_outlined,),
                        InfoCard(text: usuario.telefone, info: 'Telefone', icon: Icons.call,),
                      ],
                    ),
                  ),
                ),
              ],
            );
          })),
    );
  }
}
