import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/despesa/despesa_controller.dart';
import 'package:mobiance/app/modulos/despesa/widgets/listar_anexos_despesa.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/app/widgets/elegant_dropdown.dart';
import 'package:mobiance/app/widgets/elegant_text_field.dart';
import 'package:mobiance/utils/data_util.dart';
import 'package:mobiance/utils/preferences.dart';

class DespesaTela extends StatelessWidget {
  final DespesaController controller = new DespesaController();
  final keyForm = GlobalKey<FormState>();
  final Usuario usuario;
  final Lancamento lancamentoEdicao;
  DespesaTela({this.lancamentoEdicao, @required this.usuario});

  @override
  Widget build(BuildContext context) {
    controller.usuarioGlobal = this.usuario;
    if (this.lancamentoEdicao != null) {
      controller.lancamento = this.lancamentoEdicao;
      controller.setarAll();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corVermelha,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Despesa')),
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
                        activeColor: corVermelha,
                        onChanged: controller.onchangedAnexo,
                      )),
                  Obx(
                    () => controller.anexo
                        ? ListaAnexosDespesa(
                            controller: controller,
                          )
                        : Container(),
                  ),*/
                      ElegantTextFormField(
                        readyOnly: controller.loading,
                        initialValue: controller.setarValorDespesa(),
                        label: 'Digite o Valor da sua Despesa',
                        prefix: Text(
                          'R\$',
                          style: TextStyle(color: corVermelha),
                        ),
                        color: corVermelha,
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
                      SwitchListTile(
                        activeColor: corVermelha,
                        title: Text('O valor foi parcelado?'),
                        value: controller.isParcelado,
                        onChanged: controller.onChagedParcelado,
                      ),

                      controller.isParcelado
                          ? Align(
                              alignment: Alignment.bottomLeft,
                              child: SizedBox(
                                width: 260,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Theme(
                                    data: ThemeData(
                                        primaryColor: corVermelha,
                                        accentColor: corRoxaEscura,
                                        visualDensity: VisualDensity
                                            .adaptivePlatformDensity),
                                    child: TextFormField(
                                      readOnly: controller.loading,
                                      controller:
                                          controller.parcelaEditingController,
                                      cursorColor: corVermelha,
                                      keyboardType: TextInputType.datetime,
                                      style: TextStyle(
                                        color: corVermelha,
                                        fontSize: 18,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              32, 16, 32, 16),
                                          labelText: 'Quantas Parcelas?',
                                          filled: false,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      validator: (String valor) {
                                        if (valor.isEmpty) {
                                          return 'Não deixe o campo em branco';
                                        } else if (int.parse(valor) > 100) {
                                          return 'Só até 100';
                                        } else if (int.parse(valor) <= 1) {
                                          return 'Digite um valor de parcelas maior que um';
                                        }
                                        return null;
                                      },
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter
                                            .digitsOnly,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),

                      ElegantTextFormField(
                          readyOnly: controller.loading,
                          initialValue: controller.lancamento.titulo,
                          label: 'Digite o Título',
                          color: corVermelha,
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
                        label: 'Digite a Descrição (Opcional)',
                        color: corVermelha,
                        keyboardType: TextInputType.text,
                        padding: EdgeInsets.only(
                            top: 15, bottom: 15, left: 6, right: 6),
                        onChange: (String valor) {
                          controller.lancamento.descricao = valor;
                        },
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 6, right: 6),
                              child: Theme(
                                data: ThemeData(
                                    primaryColor: corVermelha,
                                    accentColor: corRoxaEscura,
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity),
                                child: TextFormField(
                                  readOnly: controller.loading,
                                  controller: controller.dataEditingController,
                                  cursorColor: corVermelha,
                                  keyboardType: TextInputType.datetime,
                                  style: TextStyle(
                                    color: corVermelha,
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
                                color: corVermelha,
                              ),
                              onPressed: () {
                                controller.setDataCalendario();
                              })
                        ],
                      ),
                      ElegantDropdown(
                        cor: corVermelha,
                        value: controller.selecionadoCategoria != ''
                            ? controller.selecionadoCategoria
                            : null,
                        hint: 'Selecione a Categoria',
                        items: controller.getCategorias(),
                        onChanged: controller.onChangedCategoria,
                      ),
                      /*Obx(() => SwitchListTile(
                            value: controller.isPago,
                            title: Text('O valor já foi pago?'),
                            activeColor: corVermelha,
                            onChanged: (bool valor) {
                              controller.isPago = valor;
                              controller.lancamento.pago = valor;
                            },
                          )),*/
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 10),
                        child: ElegantButton(
                          color: corVermelha,
                          label: this.lancamentoEdicao == null
                              ? !controller.loading
                                  ? 'Adicionar Despesa'
                                  : 'Salvando...'
                              : !controller.loading
                                  ? 'Editar Despesa'
                                  : 'Editando Despesa...',
                          action: !controller.loading
                              ? () {
                                  if (keyForm.currentState.validate()) {
                                    if (this.lancamentoEdicao == null) {
                                      print('entrou criação');
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
