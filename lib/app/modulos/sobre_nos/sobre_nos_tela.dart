import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/drawer/drawer_controller.dart';
import 'package:mobiance/app/modulos/drawer/widget/elegantDrawer.dart';
import 'package:mobiance/utils/preferences.dart';

class SobreNos extends StatelessWidget {
  final CustomDrawerController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ElegantDrawer(_controller.pageController),
      appBar: AppBar(
        title: Text('Sobre Nós'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'mobiance',
                            style: TextStyle(
                                fontFamily: 'Pero',
                                color: corRoxa,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Somos um App de Gestão Financeira, visando facilitar o modo como você lida com o seu dinheiro, observando gastos mensais e futuros.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[600]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                Icons.monetization_on_outlined,
                color: Colors.grey[200],
                size: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
