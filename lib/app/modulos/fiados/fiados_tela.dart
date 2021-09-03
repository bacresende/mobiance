import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/fiado_model.dart';
import 'package:mobiance/app/modulos/drawer/drawer_controller.dart';
import 'package:mobiance/app/modulos/drawer/widget/elegantDrawer.dart';
import 'package:mobiance/app/modulos/fiado/fiado_tela.dart';
import 'package:mobiance/app/modulos/fiados/fiados_controller.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:mobiance/utils/preferences.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Fiados extends StatelessWidget {
  final CustomDrawerController _controller = Get.find();
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final FiadosController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: corBranca,
        drawer: ElegantDrawer(_controller.pageController),
        appBar: AppBar(
          title: Text('Fiados'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20),
          child: Obx(() => controller.fiados.length > 0
              ? ListView.builder(
                  itemCount: controller.fiados.length,
                  itemBuilder: (_, int index) {
                    FiadoModel fiado = controller.fiados[index];

                    return Padding(
                      padding: (controller.fiados.length - 1) == index
                          ? EdgeInsets.fromLTRB(8, 8, 8, 100)
                          : EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          child: Icon(
                                            Icons.person,
                                            color: corBranca,
                                            size: 30,
                                          ),
                                          backgroundColor: fiado.isEmprestei
                                              ? corRoxa
                                              : corVermelha),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fiado.nome,
                                            style: TextStyle(
                                                color: fiado.isEmprestei
                                                    ? corRoxa
                                                    : corVermelha,
                                                fontSize: 18,
                                                fontFamily: 'Regular',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            fiado.tipoEmprestimo,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: fiado.isEmprestei
                                                    ? corRoxa
                                                    : corVermelha),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                FlatButton(
                                    child: Text(fiado.isEmprestei
                                        ? 'Receber'
                                        : 'Pagar'),
                                    color: Colors.pink,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    textColor: corBranca,
                                    onPressed: () {
                                      controller.abrirModalAddValorPago(fiado);
                                    }),
                                IconButton(
                                    tooltip: 'Excluir Empréstimo',
                                    icon: Icon(Icons.remove_circle_outline),
                                    color: Colors.pink,
                                    onPressed: () {
                                      controller
                                          .abrirDialogExcluirEmprestimo(fiado);
                                    }),
                              ],
                            ),
                            Divider(),
                            SizedBox(
                              height: 20,
                            ),
                            fiado.temDescricao
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'Descrição:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: fiado.isEmprestei
                                                      ? corRoxa
                                                      : corVermelha),
                                            ),
                                            Text(
                                              fiado.descricao,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: fiado.isEmprestei
                                                      ? corRoxa
                                                      : corVermelha),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                )
                                : Row(
                                    children: [
                                      Container(),
                                    ],
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Vencimento',
                                        style: TextStyle(
                                            color: fiado.isEmprestei
                                                ? corRoxa
                                                : corVermelha,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        fiado.data,
                                        style: TextStyle(
                                            color: fiado.isVencido
                                                ? corVermelha
                                                : corVerde,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: LinearPercentIndicator(
                                animation: true,
                                lineHeight: 10.0,
                                animationDuration: 1000,
                                percent: fiado.porcentagem,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor:
                                    fiado.isEmprestei ? corRoxa : corVermelha,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16)),
                              child: Card(
                                color:
                                    fiado.isEmprestei ? corRoxa : corVermelha,
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${fiado.isEmprestei ? 'Recebi' : 'Pago'}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: corBranca),
                                          ),
                                          Text(
                                            'R\$ ${MoedaUtil.formatarValor(fiado.valorPago)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: corBranca),
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                        child: Container(
                                          height: 20,
                                          child: VerticalDivider(
                                            color: corBranca,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Total',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  color: corBranca),
                                            ),
                                            Text(
                                              'R\$ ${MoedaUtil.formatarValor(fiado.valorTotal)}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  color: corBranca),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  child: Center(
                    child: Text(
                      'Sem Fiados',
                      style: flatButtonRoxoStyle,
                    ),
                  ),
                )),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.to(Fiado());
          },
        ));
  }
}

/*
return Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: fiado.isEmprestei
                                  ? empresteiGradiente
                                  : pegueiEmprestadoGradiente,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: ExpansionTile(
                        
                        trailing: Icon(
                          Icons.keyboard_arrow_down,
                          color: corBranca,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          child: Icon(
                                            Icons.person,
                                            color: fiado.isEmprestei
                                                ? corRoxa
                                                : corVermelha,
                                            size: 30,
                                          ),
                                          backgroundColor: corBranca),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fiado.nome,
                                            style: TextStyle(
                                                color: corBranca,
                                                fontSize: 18,
                                                fontFamily: 'Regular',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            fiado.tipoEmprestimo,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: corBranca),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            fiado.temDescricao
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Descrição:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: corBranca),
                                      ),
                                      Text(
                                        fiado.descricao,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: corBranca),
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Vencimento',
                                      style: TextStyle(
                                          color: corBranca,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      fiado.data,
                                      style: TextStyle(
                                          color: corBranca,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: LinearPercentIndicator(
                                animation: true,
                                lineHeight: 10.0,
                                animationDuration: 1000,
                                percent: fiado.porcentagem,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: corVerde,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  '${fiado.isEmprestei ? 'Recebi' : 'Pago'} R\$ ${MoedaUtil.formatarValor(fiado.valorPago)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: corBranca),
                                )),
                                Text(
                                  'Total R\$ ${MoedaUtil.formatarValor(fiado.valorTotal)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: corBranca),
                                )
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                  child: Text(
                                    fiado.isEmprestei ? 'Receber' : 'Pagar',
                                    style: TextStyle(
                                        color: fiado.isEmprestei
                                            ? corRoxa
                                            : corVermelha),
                                  ),
                                  color: corBranca,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  textColor: corBranca,
                                  onPressed: () {
                                    controller.abrirModalAddValorPago(fiado);
                                  }),
                            ),
                            /*IconButton(
                                tooltip: 'Excluir Empréstimo',
                                icon: Icon(Icons.remove_circle_outline),
                                color: Colors.pink,
                                onPressed: () {
                                  controller
                                      .abrirDialogExcluirEmprestimo(fiado);
                                }),*/
                          ],
                        ),
                        children: <Widget>[
                          Text('Big Bang'),
                          Text('Birth of the Sun'),
                          Text('Earth is Born'),
                        ],
                      ),
                    );
*/
