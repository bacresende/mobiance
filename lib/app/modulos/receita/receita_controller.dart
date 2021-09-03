import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/modulos/drawer/drawer_tela.dart';
import 'package:mobiance/app/modulos/grupos/grupos_controller.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/app/modulos/home/home_tela.dart';
import 'package:mobiance/app/widgets/elegant_dialog.dart';
import 'package:mobiance/utils/categorias.dart';
import 'package:mobiance/utils/custom_snackbar.dart';
import 'package:mobiance/utils/data_util.dart';
import 'package:mobiance/utils/get_usuario_atual.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:mobiance/utils/preferences.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReceitaController extends GetxController {
  Lancamento lancamento = new Lancamento.gerarId(tipo: 'r');
  Firestore db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Usuario usuarioGlobal;
  TextEditingController dataEditingController =
      new TextEditingController(text: '');

  RxBool _anexo = false.obs;

  bool get anexo => _anexo.value;

  set anexo(bool valor) => _anexo.value = valor;

  RxList _imagens = [].obs;
  List get imagens => _imagens.value;

  ImagePicker imagePicker = ImagePicker();

  RxString _valor = ''.obs;

  String get valor => _valor.value;

  set valor(String valor) => _valor.value = valor;

  RxString _selecionadoCategoria = ''.obs;

  String get selecionadoCategoria => _selecionadoCategoria.value;

  String dataBanco;
  List<String> fotosBanco = [];

  RxBool _loading = false.obs;

  bool get loading => _loading.value;

  set loading(bool value) => _loading.value = value;

  void onchangedAnexo(bool valor) {
    anexo = valor;

    if (!anexo) {
      _imagens.value = [];
    }
  }

  void setarAll() {
    setarDataEditingController();
    setarCategoria();
    setarDataAndFotos();
    setarAnexo();
    setarValor();
  }

  void setarDataEditingController() {
    dataEditingController.text = lancamento.data;
  }

  void setarCategoria() {
    this.selecionadoCategoria = this.lancamento.categoria;
  }

  void setarDataAndFotos() {
    this.dataBanco = this.lancamento.data;
    this.fotosBanco = this.lancamento.fotos;
  }

  void setarAnexo() {
    anexo = this.fotosBanco.length > 0;
  }

  void setarValor() {
    valor = 'R\$ ${MoedaUtil.formatarValor(lancamento.valor)}';
  }

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

  String formatarValor() {
    return lancamento.valor == null
        ? ''
        : MoedaUtil.formatarValor(lancamento.valor);
  }

  set selecionadoCategoria(String categoria) =>
      _selecionadoCategoria.value = categoria;

  void onChangedCategoria(String value) {
    selecionadoCategoria = value;
  }

  void abrirDialogSelecionarFoto() {
    showDialog(
        context: Get.context,
        builder: (context) {
          return ElegantDialog(
            corDeFundo: corVerde,
            titulo: "Selecionar Foto",
            descricao: "Deseja tirar uma foto ou pegar da galeria?",
            icone: Icons.add_a_photo,
            primeiroBotao: FlatButton(
              child: Text(
                'Tirar Foto',
                style: dialogFlatButtonRoxoStyle,
              ),
              onPressed: () async {
                getImage(isFoto: true);
              },
            ),
            segundoBotao: FlatButton(
              child: Text(
                'Galeria',
                style: dialogFlatButtonVerdeStyle,
              ),
              onPressed: () async {
                getImage(isFoto: false);
              },
            ),
          );
        });
  }

  Future getImage({bool isFoto}) async {
    PickedFile imagem;
    if (isFoto) {
      imagem = await imagePicker.getImage(source: ImageSource.camera);

      if (imagem != null) {
        if (_imagens.length < 4) {
          _imagens.add(imagem);
          Get.back();
        } else {
          Get.back();
          Get.rawSnackbar(
              message: "Máximo de fotos 4", backgroundColor: corVermelha);
        }
      }
    } else {
      imagem = await imagePicker.getImage(source: ImageSource.gallery);

      if (imagem != null) {
        if (_imagens.length < 4) {
          _imagens.add(imagem);
          Get.back();
        } else {
          Get.back();
          Get.rawSnackbar(
              message: "Máximo de fotos 4", backgroundColor: corVermelha);
        }
      }
    }
  }

  void abrirDialogExclusao(int index) {
    showDialog(
      context: Get.context,
      builder: (context) => Dialog(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
              width: double.infinity,
              height: 300,
              image: Image.file(File(imagens[index].path)).image),
          FlatButton(
            onPressed: () {
              removeItem(index);

              Get.back();
            },
            child: Text("Excluir"),
            textColor: Colors.red,
          )
        ],
      )),
    );
  }

  void removeItem(int index) {
    _imagens.removeAt(index);
  }

  List<DropdownMenuItem<String>> getCategorias() {
    List<DropdownMenuItem<String>> categorias =
        Categorias.getCategoriasReceitas();

    return categorias;
  }

  Future<void> urlToFile() async {
    Random random = new Random();
    print('fotos ${lancamento.fotos}');
    for (String urlImagem in lancamento.fotos) {
      Directory tempDir = await getTemporaryDirectory();

      String tempPath = tempDir.path;

      File file =
          new File('$tempPath' + (random.nextInt(100)).toString() + '.png');

      http.Response response = await http.get(urlImagem);

      _imagens.add(await file.writeAsBytes(response.bodyBytes));
    }
    print('fotos ${lancamento.fotos}');

    print(imagens);
  }

  Future<void> salvar() async {
    loading = true;

    if (selecionadoCategoria != '') {
      lancamento.categoria = selecionadoCategoria;
      lancamento.data = dataEditingController.text;
      salvarImagens().then((value) => salvandoDadosNoBanco());
    } else {
      loading = false;
      Get.rawSnackbar(
          message: "Selecione uma categoria", backgroundColor: corVermelha);
    }
  }

  Future<void> salvarImagens() async {
    if (imagens.isNotEmpty) {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser user = await auth.currentUser();
      for (PickedFile pickedFile in imagens) {
        //Referenciar arquivo para upload de imagens
        String nomeFoto = DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        StorageReference pastaRaiz = firebaseStorage.ref();
        StorageReference arquivo = pastaRaiz
            .child("fotos_lancamentos")
            .child(user.uid)
            .child(lancamento.idLancamento)
            .child("$nomeFoto.jpg");
        lancamento.nomeFotos.add(nomeFoto);
        StorageUploadTask task = arquivo.putFile(File(pickedFile.path));

        task.events.listen((storageEvent) {
          if (storageEvent.type == StorageTaskEventType.progress) {
            CustomSnackbar.rawSnackBar(text: 'Em progresso', cor: corRoxa);
          } else if (storageEvent.type == StorageTaskEventType.success) {
            CustomSnackbar.rawSnackBar(
                text: 'Upload realizado com sucesso', cor: corRoxa);
          } else {
            Get.rawSnackbar(
                message: "Falha ao fazer upload da foto!",
                backgroundColor: corVermelha);
          }
        });
        StorageTaskSnapshot taskSnapshot = await task.onComplete;

        String urlImagem = await taskSnapshot.ref.getDownloadURL();

        lancamento.fotos.add(urlImagem);
      }
    }
  }

  Future<void> atualizarImagens() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    this.lancamento.fotos = [];
    if (imagens.isNotEmpty) {
      for (File file in imagens) {
        //Referenciar arquivo para upload de imagens
        String nomeFoto = DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        StorageReference pastaRaiz = firebaseStorage.ref();
        StorageReference arquivo = pastaRaiz
            .child("fotos_lancamentos")
            .child(user.uid)
            .child(lancamento.idLancamento)
            .child("$nomeFoto.jpg");
        lancamento.nomeFotos.add(nomeFoto);
        StorageUploadTask task = arquivo.putFile(file);

        task.events.listen((storageEvent) {
          if (storageEvent.type == StorageTaskEventType.progress) {
            CustomSnackbar.rawSnackBar(text: 'Em progresso', cor: corRoxa);
          } else if (storageEvent.type == StorageTaskEventType.success) {
            CustomSnackbar.rawSnackBar(
                text: 'Upload realizado com sucesso', cor: corRoxa);
          } else {
            Get.rawSnackbar(
                message: "Falha ao fazer upload da foto!",
                backgroundColor: corVermelha);
          }
        });
        StorageTaskSnapshot taskSnapshot = await task.onComplete;

        String urlImagem = await taskSnapshot.ref.getDownloadURL();

        lancamento.fotos.add(urlImagem);
      }
    }
  }

  Future<void> salvandoDadosNoBanco() async {
    FirebaseUser firebaseUser = await auth.currentUser();
    String anoMes = DataUtil.getAnoMes(lancamento.data);

    print('fotos lancamento ${lancamento.fotos}');
    print('data do lancamento ${lancamento.data}');

    await db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('lancamentos')
        .document('mes')
        .collection(anoMes)
        .document(lancamento.idLancamento)
        .setData(lancamento.toMap());

    DocumentSnapshot documentSnapshot = await db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('lancamentos')
        .document('mes')
        .get();

    List datas = [];
    if (documentSnapshot.data != null) {
      datas = documentSnapshot.data['datas'];

      if (!datas.contains(anoMes)) {
        datas.add(anoMes);
      }

      datas.sort((a, b) => a.compareTo(b));
      print(datas);

      await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .setData({'datas': datas});
    } else {
      datas.add(anoMes);
      await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .setData({'datas': datas});
    }

    onSucesso();
  }

  void editar() async {
    loading = true;

    if (selecionadoCategoria != '') {
      lancamento.categoria = selecionadoCategoria;
      lancamento.data = dataEditingController.text;
      FirebaseUser firebaseUser = await auth.currentUser();
      print('lista de imagens ${imagens}');
      if (fotosBanco.isNotEmpty) {
        //Deletar fotos salvas no banco
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        StorageReference pastaRaiz = firebaseStorage.ref();
        for (String nomeFoto in lancamento.nomeFotos) {
          StorageReference arquivo = pastaRaiz
              .child("fotos_lancamentos")
              .child(firebaseUser.uid)
              .child(lancamento.idLancamento)
              .child('$nomeFoto.jpg');
          await arquivo.delete();
        }
      }

      if (imagens.isNotEmpty) {
        atualizarImagens().then((value) => editarDadosNoBanco(firebaseUser));
      } else {
        editarDadosNoBanco(firebaseUser);
      }
    } else {
      loading = false;
      Get.rawSnackbar(
          message: "Selecione uma categoria", backgroundColor: corVermelha);
    }
  }

  Future<void> editarDadosNoBanco(FirebaseUser firebaseUser) async {
    print('fotos lancamento ${lancamento.fotos}');
    print('data do lancamento ${lancamento.data}');

    print(this.dataBanco);
    print(lancamento.data);
    String anoMesBanco = DataUtil.getAnoMes(this.dataBanco);
    String anoMes = DataUtil.getAnoMes(lancamento.data);

    if (this.dataBanco != lancamento.data) {
      //Deletar o dado antigo do banco
      await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .collection(anoMesBanco)
          .document(lancamento.idLancamento)
          .delete();
      //Inserir o novo dado no banco
      await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .collection(anoMes)
          .document(lancamento.idLancamento)
          .setData(lancamento.toMap());

      DocumentSnapshot documentSnapshot = await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .get();

      List datas = [];
      if (documentSnapshot.data != null) {
        datas = documentSnapshot.data['datas'];

        QuerySnapshot querySnapshotDocuments = await db
            .collection('usuarios')
            .document(firebaseUser.uid)
            .collection('lancamentos')
            .document('mes')
            .collection(anoMesBanco)
            .getDocuments();

        if (querySnapshotDocuments.documents.length == 0) {
          if (datas.contains(anoMesBanco)) {
            datas.remove(anoMesBanco);
          }
        }

        if (!datas.contains(anoMes)) {
          datas.add(anoMes);
        }

        datas.sort((a, b) => a.compareTo(b));
        print(datas);

        await db
            .collection('usuarios')
            .document(firebaseUser.uid)
            .collection('lancamentos')
            .document('mes')
            .setData({'datas': datas});
      }
    } else {
      //Atualizar o dado no banco com a mesma data
      await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .collection(anoMes)
          .document(lancamento.idLancamento)
          .updateData(lancamento.toMap());
    }

    await onSucesso(editar: true);
  }

  Future<void> onSucesso({bool editar = false}) async {
    loading = false;
    //Get.delete<HomeController>();
    Usuario usuario;
    if (usuarioGlobal != null) {
      usuario = usuarioGlobal;
    } else {
      usuario = await UsuarioAtual.getUsuario();
    }
    GetStorage().write('usuario', usuario);
    //Get.offAll(DrawerTela());
    if (editar) {
      Get.back();
    }
    Get.back();

    Get.rawSnackbar(
        message: "Receita Adicionada com Sucesso!", backgroundColor: corRoxa);
  }
}
