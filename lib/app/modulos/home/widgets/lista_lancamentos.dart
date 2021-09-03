import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/detalhe_lancamento/detalhe_lancamento_tela.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/utils/categorias.dart';
import 'package:mobiance/utils/generatePDF.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:mobiance/utils/preferences.dart';

class ListaLancamentos extends StatelessWidget {
  final HomeController homeController = Get.find();
  

  final Usuario usuario;

  ListaLancamentos(this.usuario);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            child: Container(
              color: corBranca,
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: homeController.lancamentos.length,
                itemBuilder: (BuildContext context, int i) {
                  Lancamento lancamento = homeController.lancamentos[i];

                  var trailerCol = [
                    lancamento.tipo == 'd'
                        ? Text(
                            '- R\$ ${MoedaUtil.formatarValor(lancamento.valor)}',
                            style: TextStyle(
                                fontSize: 22,
                                color: corVermelha,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w500),
                          )
                        : Text(
                            'R\$ ${MoedaUtil.formatarValor(lancamento.valor)}',
                            style: TextStyle(
                                fontSize: 22,
                                color: corVerde,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w500),
                          )
                  ];
                  if (lancamento.parcelasFaltantes != null)
                    trailerCol.add(Text(
                      '${lancamento.parcelasFaltantes}',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ));

                  return ListTile(
                    contentPadding: (homeController.lancamentos.length - 1) == i ? EdgeInsets.fromLTRB(8, 0, 8, 100) : EdgeInsets.all(8),
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Hero(
                        tag: 'dash$i',
                        child: Categorias.getIconByCategoria(
                            categoria: lancamento.categoria ),
                      ),
                    ),
                    title: Text(
                      '${lancamento.titulo}',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: trailerCol,
                    ),
                    subtitle: Text(
                      '${lancamento.data.substring(0, 5)} ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      Get.to(DetalheLancamento(lancamento, usuario, i));
                    },
                  );
                },
              ),
            ),
          ),
        ));
  }
}
