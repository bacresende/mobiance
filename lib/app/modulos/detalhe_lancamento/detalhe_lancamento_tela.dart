import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/detalhe_lancamento/detalhe_lancamento_controller.dart';
import 'package:mobiance/app/modulos/detalhe_lancamento/widgets/card_lancamento.dart';
import 'package:mobiance/app/modulos/detalhe_lancamento/widgets/info_lancamento.dart';
import 'package:mobiance/app/widgets/info_card.dart';
import 'package:mobiance/app/modulos/ver_imagem_completa.dart/ver_imagem_completa_tela.dart';
import 'package:mobiance/utils/categorias.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:mobiance/utils/preferences.dart';

class DetalheLancamento extends StatelessWidget {
  final Lancamento lancamento;
  final Usuario usuario;
  final int index;
  final DetalheLancamentoController controller =
      new DetalheLancamentoController();

  DetalheLancamento(this.lancamento, this.usuario, this.index);
  @override
  Widget build(BuildContext context) {
    controller.lancamento = this.lancamento;
    controller.usuario = this.usuario;
    print(this.lancamento.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lancamento.titulo,
          style: TextStyle(fontSize: 25, fontFamily: 'Pero'),
        ),
        toolbarHeight: 100,
        backgroundColor: lancamento.tipo == 'd' ? corVermelha : corVerde,
        actions: [
          PopupMenuButton<String>(
            onSelected: controller.escolhaMenuItem,
            itemBuilder: (context) {
              return controller.itensMenu
                  .map((String item) => PopupMenuItem<String>(
                        child: Text(item,
                            style: TextStyle(
                                color: corRoxa,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w600)),
                        value: item,
                      ))
                  .toList();
            },
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              lancamento.fotos.isEmpty
                  ? Container()
                  : SizedBox(
                      height: 250,
                      child: Carousel(
                        images: controller.getListaImagens(),
                        autoplay: false,
                        dotSize: 8,
                        dotBgColor: Colors.transparent,
                        dotIncreasedColor:
                            lancamento.tipo == 'd' ? corVermelha : corVerde,
                        onImageTap: (int index) {
                          String foto = lancamento.fotos[index];
                          Get.to(VerImagemCompleta(foto));
                        },
                      ),
                    ),

              //se for parcelado
              //qtdeParcela
              //parcelas faltantes
              //valorTotalParcelado

              CardLancamento(
                widgets: <Widget>[
                  //Divider(),
                  InfoCard(
                    text: 'R\$  ${MoedaUtil.formatarValor(lancamento.valor)}',
                    info: 'Valor',
                    icon: Icons.monetization_on,
                  ),
                  lancamento.tipo == 'd'
                      ? Column(
                          children: [
                            lancamento.parcelado
                                ? Column(
                                    children: [
                                      InfoCard(
                                        text:
                                            'R\$  ${MoedaUtil.formatarValor(lancamento.valorTotalParcelado)}',
                                        info: 'Valor Total',
                                        icon: Icons.monetization_on_outlined,
                                      ),
                                      InfoCard(
                                        text:
                                            lancamento.qtdeParcela.toString(),
                                        info: 'Quantidade de Parcelas',
                                        icon: Icons.ballot_sharp,
                                      ),
                                      InfoCard(
                                        text:lancamento.parcelasFaltantes,
                                        info: 'Parcelas Faltantes',
                                        icon: Icons.format_list_numbered_rtl_sharp,
                                      ),
                                    ],
                                  )
                                : Container()
                          ],
                        )
                      : Container(),
                  lancamento.descricao != null
                      ? InfoCard(
                          text: lancamento.descricao,
                          info: 'Descrição',
                          icon: Icons.short_text,
                        )

                      /*InfoLancamento(
                          texto: 'Descrição',
                          valor: '${lancamento.descricao}',
                        )*/
                      : Container(),

                  InfoCard(
                    text: lancamento.data,
                    info: 'Data',
                    icon: Icons.calendar_today_outlined,
                  ),
                  /*InfoLancamento(
                    texto: 'Data',
                    valor: '${lancamento.data}',
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Hero(
                          tag: 'dash$index',
                          child: Categorias.getIconByCategoria(
                              categoria: lancamento.categoria),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Categoria'),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                lancamento.categoria,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: corRoxa,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                 /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categoria',
                        style: TextStyle(
                            color: corRoxa, fontSize: 17, fontFamily: 'Pero'),
                      ),
                      Row(
                        children: [
                          Text(
                            lancamento.categoria,
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Hero(
                            tag: 'dash$index',
                            child: Categorias.getIconByCategoria(
                                categoria: lancamento.categoria),
                          ),
                        ],
                      ),
                    ],
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
