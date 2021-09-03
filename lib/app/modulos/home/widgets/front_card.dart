import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/detalhe_lancamento/detalhe_lancamento_tela.dart';

import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/utils/categorias.dart';
import 'package:mobiance/utils/preferences.dart';

class FrontCard extends StatelessWidget {
  FrontCard({
    Key key,
  }) : super(key: key);
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Expanded(
              child: controller.lancamentos.value.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Nenhum lançamento encontrado.',
                              style:
                                  TextStyle(fontSize: 32, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: !controller.isFirst
                                      ? () {
                                          controller.retrocederLancamento();
                                        }
                                      : null,
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    controller.abrirDialogAno();
                                  },
                                  child: Text(
                                    controller.mostrarMesAtual,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward_ios),
                                      onPressed: !controller.isLast
                                          ? () {
                                              controller.avancarLancamento();
                                            }
                                          : null,
                                    ),
                                    controller.isLancamentoAtual
                                        ? Tooltip(
                                            message: 'Ir para a data atual',
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.calendar_today,
                                                  color: corRoxa,
                                                ),
                                                onPressed:
                                                    controller.irParaDataAtual))
                                        : Container()
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            
                            itemCount: controller.lancamentos.length,
                            itemBuilder: (BuildContext context, int i) {
                              Lancamento lancamento = controller.lancamentos[i];
                              return ListTile(
                                leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Categorias.getIconByCategoria(
                                      categoria: lancamento.categoria),
                                ),
                                title: Text(
                                  '${lancamento.titulo}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    lancamento.tipo == 'd'
                                        ? Text(
                                            '-R\$ ${lancamento.valor}',
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: corVermelha),
                                          )
                                        : Text(
                                            'R\$ ${lancamento.valor}',
                                            style: TextStyle(
                                                fontSize: 22, color: corVerde),
                                          ),
                                    Text(
                                      lancamento.parcelasFaltantes != null
                                          ? '${lancamento.parcelasFaltantes}'
                                          : '',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  '${lancamento.data.substring(0, 5)} ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onTap: () {
                                  Get.to(DetalheLancamento(lancamento, Usuario(), i));
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            )),
      ],
    );
  }
}
