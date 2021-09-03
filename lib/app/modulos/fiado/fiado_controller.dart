import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobiance/app/data/modelo/fiado_model.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/app/widgets/elegant_dialog.dart';
import 'package:mobiance/app/widgets/elegant_text_field.dart';
import 'package:mobiance/utils/preferences.dart';

class FiadoController extends GetxController {
  TextEditingController dataEditingController = new TextEditingController();
  FiadoModel novoFiado = new FiadoModel();
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RxString _selecionadoOpcao = ''.obs;
  RxString _selecionadoPessoa = ''.obs;
  RxBool _isEmprestei = true.obs;

  RxList<DropdownMenuItem<String>> _pessoas = <DropdownMenuItem<String>>[].obs;

  FiadoController() {
    this.setPessoas();
  }

  List<DropdownMenuItem<String>> get pessoas => _pessoas.value;

  String get selecionadoOpcao => _selecionadoOpcao.value;

  set selecionadoOpcao(String value) => _selecionadoOpcao.value = value;

  String get selecionadoPessoa => _selecionadoPessoa.value;

  set selecionadoPessoa(String value) => _selecionadoPessoa.value = value;

  bool get isEmprestei => _isEmprestei.value;

  set isEmprestei(bool value) => _isEmprestei.value = value;

  void setDataCalendario() {
    showDatePicker(
      context: Get.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2001),
      lastDate: DateTime(2200),
      cancelText: 'Cancelar',
      helpText: 'SELECIONE UMA DATA',
    ).then((DateTime dateTime) {
      String mesSelecionado;
      if (dateTime != null) {
        mesSelecionado = DateFormat('dd/MM/yyyy').format(dateTime);
      }
      dataEditingController.text = mesSelecionado;
    });
  }

  List<DropdownMenuItem<String>> getOpcoes() {
    List<DropdownMenuItem<String>> opcoes = [];

    opcoes.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.monetization_on,
            color: corRoxa,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            "Eu emprestei",
            style: TextStyle(color: corRoxa),
          ),
        ],
      ),
      value: "Eu Emprestei",
    ));
    opcoes.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.money_off,
            color: corVermelha,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Peguei Emprestado", style: TextStyle(color: corVermelha)),
        ],
      ),
      value: "Peguei Emprestado",
    ));

    return opcoes;
  }

  void onChangedOpcao(String value) {
    switch (value) {
      case 'Eu Emprestei':
        this.isEmprestei = true;
        break;
      case 'Peguei Emprestado':
        this.isEmprestei = false;

        break;
      default:
        print('deu erro');
        break;
    }
    selecionadoOpcao = value;
    novoFiado.tipoEmprestimo = value;
  }

  void setPessoas() async {
    List<FiadoModel> fiados = [];
    FirebaseUser firebaseUser = await _auth.currentUser();

    _db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('fiados')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      fiados.clear();
      fiados.addAll(querySnapshot.documents
          .map((DocumentSnapshot document) =>
              FiadoModel.fromDocumentOpcoes(document))
          .toList());

      print('nomesss $fiados');
      _pessoas.value = [];

      for (FiadoModel fiado in fiados) {
        _pessoas.add(new DropdownMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person,
                      color: isEmprestei ? corRoxa : corVermelha),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    fiado.nome,
                    style:
                        TextStyle(color: isEmprestei ? corRoxa : corVermelha),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: isEmprestei ? corRoxa : corVermelha,
                onPressed: () {
                  showModalEdit(fiado);
                },
              ),
            ],
          ),
          value: fiado.nome,
        ));
      }
    });
  }

  void showModalEdit(FiadoModel fiado) {
    showModalBottomSheet(
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          Text(
                            'O que deseja fazer com ${fiado.nome}',
                            style: TextStyle(
                                color: corRoxa,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: corRoxa,
                    ),
                    title: Text('Renomear ${fiado.nome}',
                        style: TextStyle(
                            color: corRoxa,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    onTap: () {
                      adicionarOuEditarPessoa(fiado: fiado);
                    },
                  ),
                  Divider(
                    color: corRoxa,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.remove_circle_outline,
                      color: corVermelha,
                    ),
                    title: Text('Deletar ${fiado.nome} dos contatos',
                        style: TextStyle(
                            color: corRoxa,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    onTap: () {
                      abrirDialogDeletarPessoa(fiado);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5, bottom: 8.0),
                    child: FloatingActionButton.extended(
                      backgroundColor: corRoxa,
                      elevation: 0,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: corBranca,
                      ),
                      label: Text(
                        'Voltar',
                        style: TextStyle(
                            color: corBranca,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> abrirDialogDeletarPessoa(FiadoModel fiado) async {
    showDialog(
        context: Get.context,
        builder: (context) {
          return ElegantDialog(
            corDeFundo: corVermelha,
            titulo: "Deletar Pessoa",
            descricao: "Deseja mesmo deletar ${fiado.nome} dos contatos?",
            icone: Icons.remove_circle_outline,
            primeiroBotao: FlatButton(
              child: Text(
                'Sim',
                style: dialogFlatButtonVermelhoStyle,
              ),
              onPressed: () async {
                await deletarPessoa(fiado);
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

  Future<void> deletarPessoa(FiadoModel fiado) async {
    FirebaseUser firebaseUser = await _auth.currentUser();

    await _db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('fiados')
        .document(fiado.id)
        .delete();
  }

  void adicionarOuEditarPessoa({FiadoModel fiado}) {
    String nomePessoa = '';
    if (fiado != null) {
      nomePessoa = fiado.nome;
    }
    showModalBottomSheet(
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color:
                                          isEmprestei ? corRoxa : corVermelha,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    }),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  fiado == null
                                      ? 'Adicionar Pessoa'
                                      : 'Editar Pessoa',
                                  style: TextStyle(
                                      color:
                                          isEmprestei ? corRoxa : corVermelha,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(),
                            ElegantTextFormField(
                              initialValue: nomePessoa,
                              //readyOnly: controller.loading,
                              label: 'Digite o Nome da Pessoa',
                              color: isEmprestei ? corRoxa : corVermelha,
                              keyboardType: TextInputType.text,
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 6, right: 6),
                              onChange: (String valor) {
                                nomePessoa = valor;
                                fiado.nome = valor;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20, bottom: 10, left: 16, right: 16),
                      child: ElegantButton(
                        color: isEmprestei ? corRoxa : corVermelha,
                        label: 'Salvar',
                        action: () async {
                          if (nomePessoa.isNotEmpty) {
                            print(nomePessoa);
                            await verificarSeContemNome(nomePessoa,
                                fiado: fiado);
                          } else {
                            Get.rawSnackbar(
                                message: "Não deixe o campo em branco",
                                backgroundColor: corVermelha);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> verificarSeContemNome(String nomePessoa,
      {FiadoModel fiado}) async {
    List<String> nomes = [];
    FirebaseUser firebaseUser = await _auth.currentUser();

    QuerySnapshot querySnapshot = await _db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('fiados')
        .getDocuments();

    nomes.clear();
    nomes.addAll(querySnapshot.documents
        .map((DocumentSnapshot document) => document.data['nome'] as String)
        .toList());

    if (!nomes.contains(nomePessoa)) {
      if (fiado == null) {
        salvarPessoaNoBanco(nomePessoa);
      } else {
        editarPessoaNoBanco(fiado);
        Get.back();
      }
      Future.delayed(Duration(seconds: 1), () {
        this.selecionadoPessoa = nomePessoa;
      });

      Get.back();
    } else {
      Get.rawSnackbar(
          message: "Já existe uma pessoa salva com este nome",
          backgroundColor: corVermelha);
    }
  }

  Future<void> salvarPessoaNoBanco(String nomePessoa) async {
    FirebaseUser firebaseUser = await _auth.currentUser();

    _db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('fiados')
        .add({'nome': nomePessoa});
  }

  Future<void> editarPessoaNoBanco(FiadoModel fiado) async {
    FirebaseUser firebaseUser = await _auth.currentUser();

    _db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('fiados')
        .document(fiado.id)
        .updateData({'nome': fiado.nome});
  }

  void onChangedPessoa(String value) {
    selecionadoPessoa = value;
    novoFiado.nome = value;
  }

  Future<void> salvar() async {
    if (selecionadoOpcao != '') {
      if (selecionadoPessoa != '') {
        novoFiado.nome = this.selecionadoPessoa;
        novoFiado.data = this.dataEditingController.text;
        print('ok');

        await novoFiado.salvar();
        Get.back();
        print('saiu');
      } else {
        Get.rawSnackbar(
            message: "Selecione uma Pessoa", backgroundColor: corVermelha);
      }
    } else {
      Get.rawSnackbar(
          message: "Selecione uma Opção", backgroundColor: corVermelha);
    }
  }
}
