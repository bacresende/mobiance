import 'package:flutter/material.dart';
import 'package:mobiance/app/modulos/entrar_grupo/entrar_grupo_controller.dart';
import 'package:mobiance/app/widgets/elegant_text_field.dart';

class EntrarGrupo extends StatelessWidget {
  final keyForm = GlobalKey<FormState>();
  final EntrarGrupoController controller = new EntrarGrupoController();
  final List listaGrupos;
  EntrarGrupo(this.listaGrupos);
  @override
  Widget build(BuildContext context) {
    controller.listaGrupos = listaGrupos;
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar em um Grupo'),
        actions: [
          IconButton(
              tooltip: 'Confirmar',
              icon: Icon(Icons.check),
              onPressed: () {
                if (keyForm.currentState.validate()) {
                  controller.verificarCodigo();
                }
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Form(
            key: keyForm,
            child: Column(
              children: [
                ElegantTextFormField(
                  label: 'Digite o código do grupo',
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 6, right: 6),
                  onChange: (String valor) {
                    controller.grupo.codigo = valor.trim().toUpperCase();
                    print(controller.grupo.codigo);
                  },
                  validator: (String valor) {
                    return valor.isEmpty ? 'Não deixe o campo em branco' : null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
