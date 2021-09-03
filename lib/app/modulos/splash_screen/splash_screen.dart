import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/boas_vindas/boas_vindas_tela.dart';
import 'package:mobiance/app/modulos/graficos/graficos_tela.dart';
import 'package:mobiance/app/modulos/receita/receita_tela.dart';
import 'package:mobiance/app/modulos/splash_screen/splash_screen_controller.dart';
import 'package:mobiance/utils/preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashTela extends StatelessWidget {
  final controller = new SplashScreenController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corRoxa,
      body: Stack(
        children: [
          SplashScreen(
            seconds: 2,
            navigateAfterSeconds: BoasVindas(),
            gradientBackground: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.purple[600], Colors.purple[900]]),
            loaderColor: Colors.white,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 30, left: 30, right: 40, bottom: 10),
                child: Center(
                    child: Text(
                  'M',
                  style: TextStyle(
                      color: Colors.white, fontSize: 100, fontFamily: 'Pero'),
                )),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 10),
                child: Center(
                    child: Text(
                  'Mobiance',
                  style: TextStyle(
                      color: Colors.white, fontSize: 40, fontFamily: 'Pero'),
                )),
              )
            ],
          ),
        ],
      ),
    );
  }

  

  
}
