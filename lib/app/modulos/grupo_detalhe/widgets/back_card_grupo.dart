import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/utils/preferences.dart';

import '../grupo_detalhe_controller.dart';

class BackCardGrupo extends StatelessWidget {
  BackCardGrupo({
    Key key,
    @required this.index,
    @required this.flipKey2
  }) : super(key: key);
  final GrupoDetalheController controller = Get.find();
  final GlobalKey<FlipCardState> flipKey2;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: !controller.isFirstPage()
                          ? () {
                              controller.index.value++;
                            }
                          : null,
                    ),
                    InkWell(
                      onTap: () {
                        print('teste');
                      },
                      child: Text(
                        '${controller.getNome(index)}',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: !controller.isLastPage()
                          ? () {
                              controller.index.value--;
                            }
                          : null,
                    ),
                    IconButton(
                            icon: Icon(Icons.monetization_on, color: corRoxa,),
                            onPressed: () => flipKey2.currentState.toggleCard())
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${controller.getNome(index)}',
                    style: TextStyle(fontSize: 32),
                  )
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}
