import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/cadastro/cadastro_tela.dart';
import 'package:mobiance/app/modulos/login/login_controller.dart';
import 'package:mobiance/app/modulos/resetar_senha.dart/resetar_senha_tela.dart';
import 'package:mobiance/app/widgets/elegant_appBar.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/utils/preferences.dart';
import 'package:get/get.dart';
import '../../../utils/preferences.dart';

class Login extends StatelessWidget {
  final LoginController loginController = LoginController();
  final keyForm = GlobalKey<FormState>();
  final Usuario usuario;

  Login({this.usuario});

  @override
  Widget build(BuildContext context) {
    loginController.setUsuario(this.usuario);
    
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
                    'Fazer Login',
                    style: tituloStyle,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Obx(() => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          initialValue: loginController.usuario.email ?? '',
                          onChanged: (String value) {
                            loginController.usuario.email = value;
                          },
                          readOnly: loginController.loading,
                          cursorColor: corRoxa,
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "Digite Seu E-mail",
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
                      )),
                  Obx(() => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          initialValue: loginController.usuario.senha ?? '',
                          onChanged: (String value) {
                            loginController.usuario.senha = value;
                          },
                          readOnly: loginController.loading,
                          cursorColor: corRoxa,
                          obscureText: loginController.obscure,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: loginController.obscure
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                  onPressed: loginController.setObscure),
                              contentPadding:
                                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "Digite Sua Senha",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Não deixe o campo em branco";
                            } else if (value.length <= 5) {
                              return "Digite uma senha maior que 5 digitos";
                            }
                            return null;
                          },
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                          child: Text(
                            "Não recebeu o código? Clique aqui",
                            style: TextStyle(color: Colors.grey),
                          ),
                          onPressed: () {
                            loginController.reenviarCodigo();
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                          child: Text(
                            "Esqueci minha senha",
                            style: TextStyle(color: Colors.grey),
                          ),
                          onPressed: () {
                            Get.to(ResetarSenha());
                          })
                    ],
                  ),
                  Obx(() => Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 10),
                        child: ElegantButton(
                          color: !loginController.loading ? corRoxa : corRoxaEscura,
                          label: !loginController.loading ? 'Entrar' : 'Verificando...',
                          action: !loginController.loading ? () {
                            if (keyForm.currentState.validate()) {
                              loginController.validarCampos();
                            }
                          } : (){},
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: corRoxa,
        child: FlatButton(
          child: Text(
            'Não tem conta? Clique Aqui!',
            style: TextStyle(color: corBranca, fontSize: 15),
          ),
          onPressed: () {
            Get.to(Cadastro());
          },
        ),
      ),
    );
  }
}
