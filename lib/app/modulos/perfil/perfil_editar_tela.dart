import 'package:brasil_fields/formatter/data_input_formatter.dart';
import 'package:brasil_fields/formatter/telefone_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/perfil/perfil_controller.dart';
import 'package:mobiance/app/widgets/elegant_text_field.dart';
import 'package:mobiance/app/widgets/perfil_image.dart';

class PerfilEditar extends StatelessWidget {
  final Usuario usuario;
  final PerfilEditarController controller = PerfilEditarController();
  PerfilEditar({@required this.usuario});
  final keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller.clonarUsuario(usuario);
    controller.setIcone();

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool scroll) => <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(15))),
                    expandedHeight: 250,
                    floating: false,
                    pinned: true,
                    leading: IconButton(
                        icon: Icon(Icons.close), onPressed: () => Get.back()),
                    flexibleSpace: FlexibleSpaceBar(
                      title: GestureDetector(
                        child: Text('Editar'),
                        onTap: (){
                          controller.abrirDialogIcones();
                        },
                        ),
                      centerTitle: true,
                      background: Center(
                        child: Obx(() => GestureDetector(
                              child: PerfilIcon(
                                edit: true,
                                imagemPerfil: controller.iconeSelecionado,
                                radius: 80.0,
                              ),
                              onTap: () {
                                controller.abrirDialogIcones();
                              },
                            )),
                      ),
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            if (keyForm.currentState.validate()) {
                              controller.salvarAlteracao();
                            }
                          })
                    ],
                  ),
                ),
              ],
          body: Builder(builder: (BuildContext context) {
            return CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Form(
                      key: keyForm,
                      child: Column(
                        children: [
                          ElegantTextFormField(
                            label: 'Digite seu nome',
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            initialValue: controller.usuarioClone.nome,
                            onChange: (String valor) {
                              controller.usuarioClone.nome = valor;
                            },
                            validator: (String valor) {
                              return valor.isEmpty
                                  ? 'Não deixe o campo em branco'
                                  : null;
                            },
                          ),
                          ElegantTextFormField(
                            initialValue:
                                controller.usuarioClone.dataNascimento,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              DataInputFormatter()
                            ],
                            keyboardType: TextInputType.datetime,
                            label: 'Digite sua data de nascimento',
                            onChange: (String valor) {
                              controller.usuarioClone.dataNascimento = valor;
                            },
                            validator: (String valor) {
                              if (valor.isEmpty) {
                                return "Não deixe o campo em branco";
                              } else if (valor.length < 10) {
                                return 'Digite uma data válida';
                              }
                              return null;
                            },
                          ),
                          /*ElegantTextFormField(
                            initialValue: controller.usuarioClone.telefone,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              TelefoneInputFormatter()
                            ],
                            keyboardType: TextInputType.number,
                            label: 'Digite seu telefone',
                            onChange: (String valor) {
                              controller.usuarioClone.telefone = valor;
                            },
                            validator: (String valor) => valor.isEmpty
                                ? 'Não deixe o campo em branco'
                                : null,
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          })),
    );
  }
}
