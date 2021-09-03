

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/grupo_detalhe/widgets/back_card_grupo.dart';
import 'package:mobiance/app/modulos/grupo_detalhe/widgets/body_card_grupo.dart';
import 'package:mobiance/app/modulos/grupo_detalhe/widgets/front_card_grupo.dart';

import '../grupo_detalhe_controller.dart';

class BodyGrupo extends StatelessWidget {
  BodyGrupo({
    Key key,
    @required this.flipKey2,
  }) : super(key: key);
  final GrupoDetalheController controller = Get.find();
  final GlobalKey<FlipCardState> flipKey2;

  @override
  Widget build(BuildContext context) {
    controller.lancamentoInit();
    return SliverFillRemaining(
      hasScrollBody: true,
      child: Column(children: [
        Expanded(
          child: FlipCard(
            key: flipKey2,
            flipOnTouch: false,
            front: BodyCardGrupo(
                child: Obx(() => FrontCardGrupo(index: controller.index.value, flipKey2: flipKey2))),
            back: BodyCardGrupo(
                child: Obx(() => BackCardGrupo(index: controller.index.value, flipKey2: flipKey2,))),
          ),
        ),
      ]),
    );
  }
}
