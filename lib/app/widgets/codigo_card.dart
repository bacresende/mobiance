import 'package:flutter/material.dart';
import 'package:mobiance/app/data/modelo/grupo.dart';
import 'package:mobiance/utils/preferences.dart';

class CodigoCard extends StatelessWidget {
  const CodigoCard({
    Key key,
    @required this.grupo,
  }) : super(key: key);

   final Grupo grupo;
  

  @override
  Widget build(BuildContext context) {
    return (grupo.codigo == null || grupo.codigo.trim().isEmpty)
        ? Container()
        : Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8 , 50),
            child: Row(
              children: [
                Expanded(
                    child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15,60,15,60),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            '${grupo.nomeGrupo}',
                            style: TextStyle(
                                fontSize: 22,
                                color: corRoxa,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${grupo.codigo}',
                            style: TextStyle(
                                fontSize: 27,
                                color: corRoxaEscura,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
              ],
            ),
          );
  }
}
