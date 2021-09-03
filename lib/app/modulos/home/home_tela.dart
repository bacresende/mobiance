import 'dart:ui';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/drawer/drawer_controller.dart';
import 'package:mobiance/app/modulos/drawer/widget/elegantDrawer.dart';
import 'package:mobiance/app/modulos/drawer/widget/leading_drawer.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/app/modulos/home/widgets/alternar_lancamento.dart';
import 'package:mobiance/app/modulos/home/widgets/balanco_info.dart';
import 'package:mobiance/app/modulos/despesa/despesa_tela.dart';
import 'package:mobiance/app/modulos/home/widgets/lista_lancamentos.dart';
import 'package:mobiance/app/modulos/receita/receita_tela.dart';
import 'package:mobiance/app/widgets/elegant_ButtonFloat.dart';
import 'package:mobiance/app/widgets/elegant_dialog.dart';
import 'package:mobiance/utils/generatePDF.dart';
import 'package:mobiance/utils/preferences.dart';

class Home extends StatelessWidget {
  final HomeController homeController = Get.find();
  final CustomDrawerController _controller = Get.find();

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  final Usuario usuario = GetStorage().read('usuario');
  final GlobalKey<FlipCardState> flipKey = GlobalKey<FlipCardState>();

  Home();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ElegantDrawer(_controller.pageController),
      appBar: AppBar(
        elevation: 0,
        leading: LeadingDrawer(),
        actions: [
          Tooltip(
              message: 'Recarregar',
              showDuration: Duration(seconds: 5),
              textStyle: TextStyle(color: corRoxa),
              decoration: BoxDecoration(
                color: corBranca,
              ),
              child: IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: homeController.recarregar))
        ],
      ),
      body: Obx(() => Container(
            color:
                homeController.semLancamentos ? corBranca : corRoxa,
            child: homeController.semLancamentos
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sem Lançamentos',
                          style: TextStyle(color: Colors.grey, fontSize: 28),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset('assets/imagens/sad.png', scale: 6),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          child: Text(
                            'Recarregar',
                            style: flatButtonRoxoStyle,
                          ),
                          onPressed: homeController.recarregar,
                        )
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: BalancoInfo(),
                      ),
                      AlternarLancamento(),
                      Expanded(
                        flex: 10,
                        child: ListaLancamentos(usuario),
                      ),
                    ],
                  ),
          )),
      floatingActionButton: ElegantButtonFloat(
        fabKey: fabKey,
        widgetOne: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.description,
              color: corBranca,
              size: 30,
            ),
            Text(
              'Gerar \nArquivo',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: corBranca,
              ),
            )
          ],
        ),
        onPressedOne: () {
          int tamanhoLista = homeController.lancamentos.length;

          if (tamanhoLista > 0) {
            showDialog(
                context: context,
                builder: (context) {
                  return ElegantDialog(
                    titulo: "Gerar Arquivo",
                    descricao: "Deseja criar que tipo de arquivo?",
                    icone: Icons.description,
                    primeiroBotao: FlatButton(
                      child: Text(
                        'PDF',
                        style: dialogFlatButtonRoxoStyle,
                      ),
                      onPressed: () async {
                        Get.back();
                        GeneratePDF generatePDF = GeneratePDF(
                            lista: homeController.lancamentos.value,
                            usuario: this.usuario);

                        generatePDF.generatePDFInvoice();
                      },
                    ),
                    segundoBotao: FlatButton(
                      child: Text(
                        'Excel',
                        style: dialogFlatButtonVerdeStyle,
                      ),
                      onPressed: () {
                        homeController.abrirDialogIntervaloExcel();
                      },
                    ),
                  );
                });
          } else {
            Get.rawSnackbar(
                duration: Duration(seconds: 5),
                message: "Ainda não há lançamentos para serem gerados",
                backgroundColor: corRoxa,
                icon: Icon(
                  Icons.info_outline,
                  color: corBranca,
                ));
          }
        },
        widgetTwo: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
                color: corRoxa,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  Icons.money_off,
                  color: corBranca,
                  size: 27,
                )),
            Text(
              'Despesa',
              style: TextStyle(color: corBranca),
            )
          ],
        ),
        onPressedTwo: () {
          homeController.setarValoresBalancos();
          Get.to(DespesaTela(
            usuario: usuario,
          ));
        },
        widgetThree: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monetization_on, color: corBranca, size: 32),
            Text('Receita', style: TextStyle(color: corBranca, fontSize: 16))
          ],
        ),
        onPressedThree: () {
          homeController.setarValoresBalancos();
          Get.to(ReceitaTela(
            usuario: usuario,
          ));
        },
      ),
    );
  }
}
