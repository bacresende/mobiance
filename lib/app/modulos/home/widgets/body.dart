import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/app/modulos/home/widgets/back_card.dart';
import 'package:mobiance/app/modulos/home/widgets/body_card.dart';
import 'package:mobiance/app/modulos/home/widgets/front_card.dart';

class Body extends StatelessWidget {
  Body({
    Key key,
    @required this.flipKey,
  }) : super(key: key);
  final HomeController controller = Get.find();
  final GlobalKey<FlipCardState> flipKey;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: true,
      child: Column(children: [
        Expanded(
          child: FlipCard(
              key: flipKey,
              flipOnTouch: false,
              front: BodyCard(child: FrontCard()),
              back: Container()),
        ),
      ]),
    );
  }
}
