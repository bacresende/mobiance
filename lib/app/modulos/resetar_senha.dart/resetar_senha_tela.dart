import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/modulos/resetar_senha.dart/resetar_senha_controller.dart';
import 'package:mobiance/app/widgets/elegant_appBar.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/utils/preferences.dart';

class ResetarSenha extends StatefulWidget {
  @override
  _ResetarSenhaState createState() => _ResetarSenhaState();
}

class _ResetarSenhaState extends State<ResetarSenha> {
  ResetarSenhaController senhaController = Get.put(ResetarSenhaController());
  var keyForm = GlobalKey<FormState>();
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
                    'Redefinir Senha',
                    style: tituloStyle,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      onChanged: (String value) {
                        senhaController.usuario.email = value;
                      },
                      cursorColor: Colors.greenAccent,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Digite Seu E-mail",
                          labelText: 'Digite Seu E-mail',
                          filled: false,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      validator: (String valor) {
                        if (valor.isEmpty) {
                          return "Não deixe o campo em branco";
                        } else if (!valor.contains("@")) {
                          return "Digite um email válido";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: ElegantButton(
                      label: 'Redefinir Senha',
                      action: () {
                        if (keyForm.currentState.validate()) {
                          senhaController.resetarSenha();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
