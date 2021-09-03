import 'package:flutter/material.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/utils/preferences.dart';

class InfoLancamento extends StatelessWidget {
  final String texto;
  final String valor;
  InfoLancamento({@required this.texto, @required this.valor});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  texto,
                  style: TextStyle(
                      color: corRoxa,
                      fontSize: 17,
                      fontFamily: 'Pero'),
                ),
              ),
              Expanded(
                child: Text(
                  '$valor',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
