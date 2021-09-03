import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../utils/preferences.dart';
import '../../widgets/elegant_appBar.dart';
import '../../widgets/elegant_button.dart';
import 'cadastro_controller.dart';

class Cadastro extends StatelessWidget {
  final CadastroController controller = CadastroController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  final keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElegantAppBar.elegantAppBar(),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffFFFFFF)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: keyForm,
              child: Column(
                children: <Widget>[
                  Text(
                    'Criar Conta',
                    style: tituloStyle,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        onChanged: (String value) {
                          controller.usuario.email = value;
                        },
                        readOnly: controller.loading,
                        cursorColor: corRoxa,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        onChanged: (String value) {
                          controller.usuario.senha = value;
                        },
                        readOnly: controller.loading,
                        cursorColor: corRoxa,
                        obscureText: controller.obscure,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: controller.obscure
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                onPressed: controller.setObscure),
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                    ),
                  ),
                  Obx(()=> Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: ElegantButton(
                      color: !controller.loading ? corRoxa : corRoxaEscura,
                      label: !controller.loading ? 'Entrar' : 'Verificando...',
                      action: !controller.loading ?  () {
                        if (keyForm.currentState.validate()) {
                          controller.validarCampos();
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
    );
  }

  loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      print(user.uid);
    } catch (error) {
      print(error);
    }
  }
}
