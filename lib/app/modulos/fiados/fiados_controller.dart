import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/fiado_model.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/app/widgets/elegant_dialog.dart';
import 'package:mobiance/app/widgets/elegant_text_field.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:mobiance/utils/preferences.dart';

class FiadosController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    this.carregarFiados();
  }

  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RxList<FiadoModel> _fiados = <FiadoModel>[].obs;

  List<FiadoModel> get fiados => _fiados.value;

  Future<void> carregarFiados() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    print(firebaseUser);

    _db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('emprestimos')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      _fiados.value = [];
      _fiados.addAll(querySnapshot.documents
          .map((DocumentSnapshot documentSnapshot) =>
              FiadoModel.fromDocumentDataBase(documentSnapshot))
          .toList());
    });
  }

  void abrirModalAddValorPago(FiadoModel fiado) {
    print(fiado.toMap());
    String valorPagoDigitado = '';
    RxString opcaoDePagamento = 'Pagar tudo'.obs;

    showModalBottomSheet(
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Obx(() => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: fiado.isEmprestei
                                            ? corRoxa
                                            : corVermelha,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      }),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Adicionar Valor',
                                    style: TextStyle(
                                        color: fiado.isEmprestei
                                            ? corRoxa
                                            : corVermelha,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Divider(),
                              RadioListTile(
                                  title: Text('Pagar tudo'),
                                  value: 'Pagar tudo',
                                  activeColor:
                                      fiado.isEmprestei ? corRoxa : corVermelha,
                                  groupValue: opcaoDePagamento.value,
                                  onChanged: (String value) {
                                    opcaoDePagamento.value = value;
                                    valorPagoDigitado = '';
                                  }),
                              RadioListTile(
                                  title: Text('Pagar parcialmente'),
                                  value: 'Pagar parcialmente',
                                  activeColor:
                                      fiado.isEmprestei ? corRoxa : corVermelha,
                                  groupValue: opcaoDePagamento.value,
                                  onChanged: (String value) {
                                    print(value);
                                    opcaoDePagamento.value = value;
                                    valorPagoDigitado = '';
                                  }),
                              opcaoDePagamento.value == 'Pagar parcialmente'
                                  ? ElegantTextFormField(
                                      //readyOnly: controller.loading,
                                      hint:
                                          'Faltam R\$ ${MoedaUtil.formatarValor(fiado.subtrairTotalDoValorPago)}',
                                      label: 'Digite o valor pago ',
                                      prefix: Text(
                                        'R\$',
                                        style: TextStyle(
                                            color: fiado.isEmprestei
                                                ? corRoxa
                                                : corVermelha),
                                      ),
                                      color: fiado.isEmprestei
                                          ? corRoxa
                                          : corVermelha,
                                      keyboardType: TextInputType.number,
                                      padding: EdgeInsets.only(
                                          top: 15,
                                          bottom: 15,
                                          left: 6,
                                          right: 6),
                                      onChange: (String valor) {
                                        valor = valor.replaceAll('.', '');
                                        valor = valor.replaceAll(',', '.');
                                        valorPagoDigitado = valor;
                                      },
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter
                                            .digitsOnly,
                                        RealInputFormatter(centavos: true),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 10, left: 16, right: 16),
                          child: ElegantButton(
                            color: fiado.isEmprestei ? corRoxa : corVermelha,
                            label: 'Salvar',
                            action: () async {
                              salvarAddValorPago(opcaoDePagamento.value,
                                  valorPagoDigitado, fiado);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  Future<void> salvarAddValorPago(String opcaoDePagamento,
      String valorPagoDigitado, FiadoModel fiado) async {
    if (opcaoDePagamento == 'Pagar parcialmente') {
      if (valorPagoDigitado.isNotEmpty) {
        await fiado.atualizarValorPagoNoBanco(valorPagoDigitado);
      } else {
        Get.rawSnackbar(
            message: "Não deixe o campo em branco",
            backgroundColor: corVermelha);
      }
    } else {
      await fiado.deletarEmprestimo();
      Get.back();
      Get.rawSnackbar(
          title: 'Empréstimo Finalizado!',
          message: fiado.isEmprestei
              ? '${fiado.nome} terminou de pagar você'
              : 'Você terminou de pagar ${fiado.nome}',
          backgroundColor: corVerde);
    }
  }

  void abrirDialogExcluirEmprestimo(FiadoModel fiado) {
    showDialog(
        context: Get.context,
        builder: (context) {
          return ElegantDialog(
            corDeFundo: corVermelha,
            titulo: "Deletar Empréstimo",
            descricao: "Deseja mesmo deletar empréstimo de ${fiado.nome}?",
            icone: Icons.remove_circle_outline,
            primeiroBotao: FlatButton(
              child: Text(
                'Sim',
                style: dialogFlatButtonVermelhoStyle,
              ),
              onPressed: () async {
                await fiado.deletarEmprestimo();
                Get.back();
                Get.back();
              },
            ),
            segundoBotao: FlatButton(
              child: Text(
                'Não',
                style: dialogFlatButtonRoxoStyle,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          );
        });
  }
}
