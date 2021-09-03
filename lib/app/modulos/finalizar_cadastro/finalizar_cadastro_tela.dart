import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/finalizar_cadastro/finalizar_cadastro_controller.dart';
import 'package:mobiance/app/widgets/elegant_appBar.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/utils/validar_cpf.dart';

import '../../../utils/preferences.dart';

class FinalizarCadastro extends StatelessWidget {
  final keyForm = GlobalKey<FormState>();
  final FinalizarCadastroController controller = FinalizarCadastroController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElegantAppBar.elegantAppBar(),
      body: Container(
        decoration: BoxDecoration(color: corBranca),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: keyForm,
              child: Column(
                children: <Widget>[
                  Text(
                    'Finalizar Cadastro',
                    style: tituloStyle,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  //TODO: fazer a seleção de icones

                  Obx(
                    () => controller.iconeSelecionado == ''
                        ? GestureDetector(
                            onTap: !controller.loading
                                ? () {
                                    controller.abrirDialogIcones();
                                  }
                                : () {},
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Icon(
                                        Icons.person_pin,
                                        size: 80,
                                        color: corRoxa,
                                      )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Selecione um ícone",
                                        style: TextStyle(
                                            color: corRoxa,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        "(Opcional)",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: !controller.loading
                                ? () {
                                    controller.abrirDialogIcones();
                                  }
                                : () {},
                            child: CircleAvatar(
                              child: Image.asset(controller.iconeSelecionado),
                              radius: 60,
                              backgroundColor: corRoxa,
                            ),
                          ),
                  ),

                  Obx(() => Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 15.0),
                        child: TextFormField(
                          onChanged: (String value) {
                            controller.usuario.nome = value;
                          },
                          readOnly: controller.loading,
                          cursorColor: Colors.greenAccent,
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "Digite Seu Nome",
                              labelText: 'Digite Seu Nome',
                              filled: false,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          validator: (String valor) {
                            if (valor.isEmpty) {
                              return "Não deixe o campo em branco";
                            }
                            return null;
                          },
                        ),
                      )),
                  /*Obx(() => Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          onChanged: (String value) {
                            controller.usuario.telefone = value;
                          },
                          readOnly: controller.loading,
                          cursorColor: Colors.greenAccent,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "Digite Seu Telefone",
                              labelText: "Digite Seu Telefone",
                              filled: false,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          validator: (String valor) {
                            if (valor.isEmpty) {
                              return "Não deixe o campo em branco";
                            }
                            return null;
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                        ),
                      )),
                  Obx(() => Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          onChanged: (String value) {
                            value =
                                value.replaceAll('.', '').replaceAll('-', '');
                            print(value);
                            controller.usuario.cpf = value;
                          },
                          readOnly: controller.loading,
                          cursorColor: Colors.greenAccent,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "Digite Seu CPF",
                              labelText: "Digite Seu CPF",
                              filled: false,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          validator: (String valor) {
                            if (valor.isEmpty) {
                              return "Não deixe o campo em branco";
                            } else if (valor.length < 11) {
                              return 'Digite um CPF de 11 dígitos';
                            } else if (!ValidarCPF.isCpfValidado(valor)) {
                              return 'CPF Incorreto';
                            }
                            return null;
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            CpfInputFormatter()
                          ],
                        ),
                      )),*/
                  Obx(() => Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          onChanged: (String value) {
                            controller.usuario.dataNascimento = value;
                          },
                          readOnly: controller.loading,
                          cursorColor: Colors.greenAccent,
                          autofocus: true,
                          keyboardType: TextInputType.datetime,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "Digite Sua Data de Nascimento",
                              labelText: "Data de Nascimento",
                              filled: false,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          validator: (String valor) {
                            if (valor.isEmpty) {
                              return "Não deixe o campo em branco";
                            } else if (valor.length < 10) {
                              return 'Digite uma data válida';
                            }
                            return null;
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            DataInputFormatter()
                          ],
                        ),
                      )),
                  Obx(() => Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 10),
                        child: ElegantButton(
                          color: !controller.loading ? corRoxa : corRoxaEscura,
                          label:
                              !controller.loading ? 'Finalizar' : 'Finalizando...',
                          action: !controller.loading
                              ? () {
                                  if (keyForm.currentState.validate()) {
                                    controller.validarCampos();
                                  }
                                }
                              : () {},
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
