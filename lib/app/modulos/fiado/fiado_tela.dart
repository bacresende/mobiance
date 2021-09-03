import 'package:brasil_fields/brasil_fields.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/drawer/drawer_controller.dart';
import 'package:mobiance/app/modulos/fiado/fiado_controller.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/app/widgets/elegant_dropdown.dart';
import 'package:mobiance/app/widgets/elegant_text_field.dart';
import 'package:mobiance/utils/data_util.dart';
import 'package:mobiance/utils/preferences.dart';

class Fiado extends StatelessWidget {
  final FiadoController controller = FiadoController();
  final keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: controller.isEmprestei ? corRoxa : corVermelha,
            title: Text('Novo Empréstimo'),
          ),
          body: Container(
            padding: EdgeInsets.only(top: 20),
            child: Form(
              key: keyForm,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                    child: ElegantDropdown(
                      cor: controller.isEmprestei ? corRoxa : corVermelha,
                      value: controller.selecionadoOpcao != ''
                          ? controller.selecionadoOpcao
                          : null,
                      hint: 'Selecione a Opção',
                      items: controller.getOpcoes(),
                      onChanged: controller.onChangedOpcao,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() => ElegantDropdown(
                                cor: controller.isEmprestei
                                    ? corRoxa
                                    : corVermelha,
                                value: controller.selecionadoPessoa != ''
                                    ? controller.selecionadoPessoa
                                    : null,
                                hint: 'Selecione a Pessoa',
                                items: controller.pessoas,
                                onChanged: controller.onChangedPessoa,
                              )),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.person_add,
                              color: controller.isEmprestei
                                  ? corRoxa
                                  : corVermelha,
                            ),
                            onPressed: () {
                              controller.adicionarOuEditarPessoa();
                            })
                      ],
                    ),
                  ),
                  ElegantTextFormField(
                    //readyOnly: controller.loading,
                    label: 'Digite o Valor',
                    prefix: Text(
                      'R\$',
                      style: TextStyle(
                          color:
                              controller.isEmprestei ? corRoxa : corVermelha),
                    ),
                    color: controller.isEmprestei ? corRoxa : corVermelha,
                    keyboardType: TextInputType.number,
                    padding:
                        EdgeInsets.only(top: 15, bottom: 15, left: 6, right: 6),
                    onChange: (String valor) {
                      valor = valor.replaceAll('.', '');
                      valor = valor.replaceAll(',', '.');
                      controller.novoFiado.valorTotal = valor;
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
                    //readyOnly: controller.loading,
                    label: 'Digite a Descrição (Opcional)',
                    color: controller.isEmprestei ? corRoxa : corVermelha,
                    keyboardType: TextInputType.text,
                    padding:
                        EdgeInsets.only(top: 15, bottom: 15, left: 6, right: 6),
                    onChange: (String valor) {
                      controller.novoFiado.descricao = valor;
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
                                primaryColor: controller.isEmprestei
                                    ? corRoxa
                                    : corVermelha,
                                accentColor: controller.isEmprestei
                                    ? corRoxa
                                    : corVermelha,
                                visualDensity:
                                    VisualDensity.adaptivePlatformDensity),
                            child: TextFormField(
                              //readOnly: controller.loading,
                              controller: controller.dataEditingController,
                              cursorColor: corVerde,
                              keyboardType: TextInputType.datetime,
                              style: TextStyle(
                                color: controller.isEmprestei
                                    ? corRoxa
                                    : corVermelha,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(32, 16, 32, 16),
                                  labelText: 'Digite a Data',
                                  filled: false,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              validator: (String data) {
                                String anoMesDia;

                                if (data.isNotEmpty && data.length == 10) {
                                  anoMesDia = DataUtil.getAnoMesDia(data);
                                }

                                if (data.isEmpty) {
                                  return "Não deixe o campo em branco";
                                } else if (data.length < 10) {
                                  return 'Digite uma data válida';
                                } else if (!DataUtil.isValidDate(anoMesDia)) {
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
                            color:
                                controller.isEmprestei ? corRoxa : corVermelha,
                          ),
                          onPressed: () {
                            controller.setDataCalendario();
                          })
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 10, left: 16, right: 16),
                    child: ElegantButton(
                      color: controller.isEmprestei ? corRoxa : corVermelha,
                      label: 'Salvar',
                      action: () async {
                        if (keyForm.currentState.validate()) {
                          print('entrou');
                          await controller.salvar();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
