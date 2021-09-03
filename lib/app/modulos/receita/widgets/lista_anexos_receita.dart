import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:mobiance/app/modulos/receita/receita_controller.dart';
import 'package:mobiance/utils/preferences.dart';

class ListaAnexosReceita extends StatelessWidget {
  final ReceitaController controller;

  ListaAnexosReceita({this.controller});
  @override
  Widget build(BuildContext context) {
    if (controller.lancamento.fotos.isNotEmpty) {
      print('sim ${controller.lancamento.fotos.length}');
      controller.urlToFile();
    }else{
      print('naão');
    }

    return Obx(() => Container(
          height: 100,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.imagens.length + 1,
              itemBuilder: (context, index) {
                if (controller.imagens.length == index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                        onTap: () {
                          controller.abrirDialogSelecionarFoto();
                        },
                        child: CircleAvatar(
                          backgroundColor: corVerde,
                          radius: 45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: Colors.grey[100],
                              ),
                              Text(
                                "Adicionar",
                                style: TextStyle(
                                    color: Colors.grey[100], fontSize: 13),
                              )
                            ],
                          ),
                        )),
                  );
                }
                if (controller.imagens.length > 0) {
                  return Obx(
                    () => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                          onTap: () {
                            controller.abrirDialogExclusao(index);
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                Image.file(File(controller.imagens[index].path))
                                    .image,
                            radius: 50,
                            child: Container(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          )),
                    ),
                  );
                }
                return Container();
              }),
        ));
  }
}
