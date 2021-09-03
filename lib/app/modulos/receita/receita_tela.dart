import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/receita/receita_controller.dart';
import 'package:mobiance/app/modulos/receita/widgets/lista_anexos_receita.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/app/widgets/elegant_dropdown.dart';
import 'package:mobiance/app/widgets/elegant_text_field.dart';
import 'package:mobiance/utils/data_util.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:mobiance/utils/preferences.dart';
import 'dart:async';
import 'dart:io';

class ReceitaTela extends StatelessWidget {
  final ReceitaController controller = new ReceitaController();
  final keyForm = GlobalKey<FormState>();
  final Lancamento lancamentoEdicao;
  final Usuario usuario;
  ReceitaTela({this.lancamentoEdicao, @required this.usuario});

  @override
  Widget build(BuildContext context) {
    controller.usuarioGlobal = this.usuario;
    if (this.lancamentoEdicao != null) {
      controller.lancamento = this.lancamentoEdicao;

      controller.setarAll();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corVerde,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Receita')),
            Obx(() => Expanded(
                    child: Text(
                  controller.valor,
                  overflow: TextOverflow.ellipsis,
                ))),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: keyForm,
              child: Obx(() => Column(
                    children: [
                      //Achar uma forma de reduzir a qualidade da imagem para caber no storage
                      /*Obx(() => SwitchListTile(
                        value: controller.anexo,
                        title: Text('Deseja inserir anexos?'),
                        subtitle: Text('Opcional'),
                        activeColor: corVerde,
                        onChanged: controller.onchangedAnexo,
                      )),
                  Obx(
                    () => controller.anexo
                        ? ListaAnexosReceita(
                            controller: controller,
                          )
                        : Container(),
                  ),*/
                      ElegantTextFormField(
                        readyOnly: controller.loading,
                        initialValue: controller.formatarValor(),
                        label: 'Digite o Valor da sua Receita',
                        prefix: Text(
                          'R\$',
                          style: TextStyle(color: corVerde),
                        ),
                        color: corVerde,
                        keyboardType: TextInputType.number,
                        padding: EdgeInsets.only(
                            top: 15, bottom: 15, left: 6, right: 6),
                        onChange: (String valor) {
                          controller.valor = 'R\$ $valor';
                          valor = valor.replaceAll('.', '');
                          valor = valor.replaceAll(',', '.');
                          controller.lancamento.valor = valor;
                        },
                        validator: (String valor) {
                          return valor.isEmpty
                              ? 'Não deixe o campo em branco'
                              : null;
                        },
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          RealInputFormatter(centavos: true),
                        ],
                      ),
                      ElegantTextFormField(
                          readyOnly: controller.loading,
                          initialValue: controller.lancamento.titulo,
                          label: 'Digite o Título',
                          color: corVerde,
                          keyboardType: TextInputType.text,
                          padding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 6, right: 6),
                          onChange: (String valor) {
                            controller.lancamento.titulo = valor;
                          },
                          validator: (String valor) {
                            return valor.isEmpty
                                ? 'Não deixe o campo em branco'
                                : null;
                          }),
                      ElegantTextFormField(
                          readyOnly: controller.loading,
                          initialValue: controller.lancamento.descricao,
                          label: 'Digite a Descrição (Opcional)',
                          color: corVerde,
                          keyboardType: TextInputType.text,
                          padding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 6, right: 6),
                          onChange: (String valor) {
                            controller.lancamento.descricao = valor;
                          }),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 6, right: 6),
                              child: Theme(
                                data: ThemeData(
                                    primaryColor: corVerde,
                                    accentColor: corRoxaEscura,
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity),
                                child: TextFormField(
                                  readOnly: controller.loading,
                                  controller: controller.dataEditingController,
                                  cursorColor: corVerde,
                                  keyboardType: TextInputType.datetime,
                                  style: TextStyle(
                                    color: corVerde,
                                    fontSize: 18,
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(32, 16, 32, 16),
                                      labelText: 'Digite a Data',
                                      filled: false,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  validator: (String data) {
                                    String anoMesDia;

                                    if (data.isNotEmpty && data.length == 10) {
                                      anoMesDia = DataUtil.getAnoMesDia(data);
                                    }

                                    if (data.isEmpty) {
                                      return "Não deixe o campo em branco";
                                    } else if (data.length < 10) {
                                      return 'Digite uma data válida';
                                    } else if (!DataUtil.isValidDate(
                                        anoMesDia)) {
                                      return 'Digite uma data válida';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    DataInputFormatter()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.calendar_today_outlined,
                                color: corVerde,
                              ),
                              onPressed: () {
                                controller.setDataCalendario();
                              })
                        ],
                      ),
                      ElegantDropdown(
                        cor: corVerde,
                        value: controller.selecionadoCategoria != ''
                            ? controller.selecionadoCategoria
                            : null,
                        hint: 'Selecione a Categoria',
                        items: controller.getCategorias(),
                        onChanged: controller.onChangedCategoria,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 10),
                        child: ElegantButton(
                          color: corVerde,
                          label: this.lancamentoEdicao == null
                              ? !controller.loading
                                  ? 'Adicionar Receita'
                                  : 'Salvando...'
                              : !controller.loading
                                  ? 'Editar Receita'
                                  : 'Editando Receita...',
                          action: !controller.loading
                              ? () {
                                  if (keyForm.currentState.validate()) {
                                    if (this.lancamentoEdicao == null) {
                                      controller.salvar();
                                    } else {
                                      controller.editar();
                                    }
                                  }
                                }
                              : () {},
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
