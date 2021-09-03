import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/balanco_futuro/balanco_futuro_tela.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/utils/preferences.dart';

class BalancoInfo extends StatelessWidget {
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: (){
                  homeController.abrirDialogBalancoMensal();
                },
                child: Column(
                  children: [
                    Text(
                      'Balanço Mensal',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.w600),
                    ),
                    
                    Text(
                      '${homeController.balancoMensal.string}',
                      style: TextStyle(
                          fontSize: 21,
                          color: homeController.balancoMensalValido.value
                              ? Colors.white
                              : Colors.orange,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                color: Colors.white,
              ),
              GestureDetector(
                onTap: () {
                  if (homeController.lancamentosBalanco.isNotEmpty) {
                    Get.to(BalancoFuturo());
                  } else {
                    Get.rawSnackbar(
                        duration: Duration(seconds: 5),
                        message: "Ainda não há balanço futuros",
                        backgroundColor: corRoxa,
                        icon: Icon(
                          Icons.info_outline,
                          color: corBranca,
                        ));
                  }
                },
                child: Column(
                  children: [
                    Text(
                      'Balanço Futuro',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${homeController.balancoFuturo.string}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 21,
                          color: homeController.balancoFuturoValido.value
                              ? Colors.white
                              : Colors.orange,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
