import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobiance/utils/preferences.dart';

import '../grupo_detalhe_controller.dart';

class FrontCardGrupo extends StatelessWidget {
  FrontCardGrupo({
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
                            icon: Icon(FontAwesomeIcons.chartBar, color: corRoxa,),
                            onPressed: () => flipKey2.currentState.toggleCard())
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.getMap(index).length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      leading: Icon(Icons.attach_money),
                      title: Text(
                        'R\$ ${controller.getMap(index).values.elementAt(i)}',
                        style: TextStyle(fontSize: 24),
                      ),
                      trailing:
                          Text('${controller.getMap(index).keys.elementAt(i)}'),
                      subtitle: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              'Salário ',
                              style: TextStyle(color: corRoxa),
                            ),
                            Text(
                              'Teste ',
                              style: TextStyle(color: corRoxa),
                            ),
                            Text(
                              'Escola ',
                              style: TextStyle(color: corRoxa),
                            ),
                            Text(
                              'Amigos ',
                              style: TextStyle(color: corRoxa),
                            ),
                            Text(
                              'Feriado ',
                              style: TextStyle(color: corRoxa),
                            ),
                            Text(
                              'Salário ',
                              style: TextStyle(color: corRoxa),
                            ),
                            Text(
                              'Salário ',
                              style: TextStyle(color: corRoxa),
                            ),
                            Text(
                              'Salário ',
                              style: TextStyle(color: corRoxa),
                            ),
                            Text(
                              'Salário ',
                              style: TextStyle(color: corRoxa),
                            ),
                            Text(
                              'Salário ',
                              style: TextStyle(color: corRoxa),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
