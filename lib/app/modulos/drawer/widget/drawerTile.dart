import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/boas_vindas/boas_vindas_tela.dart';
import 'package:mobiance/app/widgets/elegant_dialog.dart';
import 'package:mobiance/utils/get_usuario_atual.dart';
import 'package:mobiance/utils/info_feature_snackbar.dart';
import 'package:mobiance/utils/perfil_utils.dart';
import 'package:mobiance/utils/preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawerController.dart';

class DrawerTile extends StatelessWidget {
  final DrawerTileController drawerController = Get.put(DrawerTileController());
  final IconData icon;
  final Usuario usuario;
  final String text;

  final PageController controller;
  final int page;

  DrawerTile({this.icon, this.text, this.page, this.controller, this.usuario});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (page == 5) {
            Get.back();
            showDialog(
                context: context,
                builder: (context) {
                  return ElegantDialog(
                    titulo: "Entre em Contato",
                    descricao:
                        "Deseja entrar em contato por meio de qual canal?",
                    icone: Icons.contacts,
                    primeiroBotao: FlatButton(
                      child: Text(
                        'E-mail',
                        style: dialogFlatButtonRoxoStyle,
                      ),
                      onPressed: () async {
                        Get.back();
                        String mensagem;
            

                        DateTime data = DateTime.now();

                        if (data.hour >= 0 && data.hour <= 11) {
                          mensagem = 'Bom%20dia,%20';
                        } else if (data.hour >= 12 && data.hour <= 17) {
                          mensagem = 'Boa%20tarde,%20';
                        } else {
                          mensagem = 'Boa%20noite,%20';
                        }

                        mensagem += 'me%20chamo%20${usuario.nome}%20e%20';

                        mensagem += 'gostaria%20de%20tirar%20uma%20dúvida';
                        String emailMobiance = 'mobiance.contato@gmail.com';
                        String urlEmail =
                            'mailto:$emailMobiance?subject=Dúvida%20Mobiance&body=$mensagem';
                        await launch(urlEmail);
                      },
                    ),
                    segundoBotao: FlatButton(
                      child: Text(
                        'WhatsApp',
                        style: dialogFlatButtonVerdeStyle,
                      ),
                      onPressed: () async {
                        Firestore db = Firestore.instance;
                        Get.back();
                        String mensagem;
                        DateTime data = DateTime.now();

                        DocumentSnapshot documentSnapshot = await db
                            .collection('aux')
                            .document('contato')
                            .get();
                        String telefoneMobiance = documentSnapshot.data['telefone'];
                        String primeiroNome = PerfilUtils.getPrimeiroNome(usuario.nome);

                        if (data.hour >= 0 && data.hour <= 11) {
                          mensagem = 'Bom%20dia,%20';
                        } else if (data.hour >= 12 && data.hour <= 17) {
                          mensagem = 'Boa%20tarde,%20';
                        } else {
                          mensagem = 'Boa%20noite,%20';
                        }
                        mensagem +=
                            'me%20chamo%20$primeiroNome%20e%20';
                        mensagem += 'gostaria%20de%20tirar%20uma%20dúvida';

                        String urlWhats =
                            'https://api.whatsapp.com/send?phone=$telefoneMobiance&text=$mensagem';
                        await launch(urlWhats);
                      },
                    ),
                  );
                });
          } else if (page == 1) {
            //Quando o módulo de grupo estiver pronto, remover esse 'else if'
            Get.back();
            InfoFeatureSnackbar.snackbar('Grupos');
          } else {
            if (page != 6) {
              Get.back();
              controller.jumpToPage(page);
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ElegantDialog(
                      titulo: 'Sair do App',
                      descricao: "Deseja deslogar da sua conta?",
                      icone: Icons.exit_to_app_rounded,
                      primeiroBotao: FlatButton(
                        child: Text(
                          'Não',
                          style: dialogFlatButtonRoxoStyle,
                        ),
                        onPressed: () async {
                          Get.back();
                        },
                      ),
                      segundoBotao: FlatButton(
                        child: Text(
                          'Sim',
                          style: dialogFlatButtonVerdeStyle,
                        ),
                        onPressed: () async {
                          Get.back();
                          drawerController.logout();
                          Get.offAll(BoasVindas());
                        },
                      ),
                    );
                  });
            }
          }
        },
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(icon,
                    color: controller.page.round() == page
                        ? corBranca
                        : Colors.grey[500]),
                SizedBox(
                  width: 32,
                ),
                Text(
                  this.text,
                  style: TextStyle(
                      color: controller.page.round() == page
                          ? corBranca
                          : Colors.grey[500],
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
