import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/criar_grupo/criar_grupo_controller.dart';
import 'package:mobiance/app/widgets/codigo_card.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/app/widgets/elegant_text_field.dart';

class CriarGrupo extends StatelessWidget {
  final CriarGrupoController controller = new CriarGrupoController();
  final keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() =>
            Text(!controller.grupoCriado ? 'Criar Grupo' : 'Grupo Criado')),
        actions: [
          Obx(() => !controller.grupoCriado
              ? IconButton(
                  tooltip: 'Confirmar',
                  icon: Icon(Icons.check),
                  onPressed: () {
                    if (keyForm.currentState.validate()) {
                      controller.criarGrupo();
                    }
                  })
              : Container()),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Form(
            key: keyForm,
            child: Column(
              children: [
                Obx(
                  () => !controller.grupoCriado
                      ? Column(
                          children: [
                            ElegantTextFormField(
                              label: 'Digite o valor do seu salário',
                              keyboardType: TextInputType.number,
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 6, right: 6),
                              onChange: (String valor) {
                                valor = valor.replaceAll('.', '');
                                valor = valor.replaceAll(',', '.');
                                controller.grupo.salario = valor;
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
                              label: 'Digite o nome do grupo',
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 6, right: 6),
                              onChange: (String valor) {
                                controller.grupo.nomeGrupo = valor;
                              },
                              validator: (String valor) {
                                return valor.isEmpty
                                    ? 'Não deixe o campo em branco'
                                    : null;
                              },
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            CodigoCard(grupo: controller.grupo),
                            Positioned(
                                left: 75,
                                top: 143,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 16, bottom: 10),
                                  child: ElegantButton(
                                    label: 'Enviar Código',
                                    width: 200,
                                    action: controller.share,
                                  ),
                                )),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
