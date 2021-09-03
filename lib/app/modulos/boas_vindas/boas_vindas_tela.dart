import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/boas_vindas/boas_vindas_controller.dart';
import 'package:mobiance/app/modulos/cadastro/cadastro_tela.dart';
import 'package:mobiance/app/modulos/login/login_tela.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/utils/icones_pessoa.dart';
import 'package:mobiance/utils/preferences.dart';

class BoasVindas extends StatefulWidget {
  @override
  _BoasVindasState createState() => _BoasVindasState();
}

class _BoasVindasState extends State<BoasVindas> {
  BoasVindasController controller = new BoasVindasController();
  @override
  void initState() {
    super.initState();
    controller.verificarUsuarioAtivo();
    print('ios? ${GetPlatform.isIOS}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top:50),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.purple[600], Colors.purple[900]],
        )),
        child: Center(
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'mobiance',
                  style: TextStyle(
                      fontFamily: 'Pero',
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Image.asset('assets/imagens/logo.png'),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: ElegantButton(
                  color: Colors.white,
                  textStyle: TextStyle(
                      color: corRoxa,
                      fontSize: 18,
                      fontFamily: 'Pero',
                      fontWeight: FontWeight.bold),
                  action: () => Get.to(Cadastro()),
                  label: 'Criar Conta',
                ),
              ),
              FlatButton(
                  child: Text(
                    'Já tem uma conta? Clique para logar',
                    style: TextStyle(
                      fontFamily: 'Pero',
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => Get.to(Login())),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Divider(
                      color: corBranca,
                      endIndent: 20,
                      indent: 80,
                    )),
                    Text(
                      'Ou',
                      style: flatButtonBrancoStyle,
                    ),
                    Expanded(
                        child: Divider(
                      color: corBranca,
                      endIndent: 80,
                      indent: 20,
                    ))
                  ],
                ),
              ),
              Column(
                children: [
                  Obx(() => controller.carregando
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(corBranca))
                      : Container(
                          child: OutlineButton.icon(
                            icon: FaIcon(
                              FontAwesomeIcons.google,
                              color: corBranca,
                            ),
                            label: Text(
                              'Fazer Login com o Google',
                              style: TextStyle(fontFamily: 'Pero'),
                            ),
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            highlightedBorderColor: corBranca,
                            borderSide: BorderSide(color: corBranca),
                            textColor: corBranca,
                            onPressed: () {
                              controller.loginComGoogle();
                            },
                          ),
                        ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
