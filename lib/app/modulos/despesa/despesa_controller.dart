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
import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/app/widgets/elegant_dialog.dart';
import 'package:mobiance/utils/categorias.dart';
import 'package:mobiance/utils/custom_snackbar.dart';
import 'package:mobiance/utils/data_util.dart';
import 'package:mobiance/utils/get_usuario_atual.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:mobiance/utils/preferences.dart';
import 'dart:async';
import 'dart:io';

class DespesaController extends GetxController {
  Lancamento lancamento = new Lancamento.gerarId(tipo: 'd');
  TextEditingController dataEditingController =
      new TextEditingController(text: '');
      TextEditingController parcelaEditingController =
      new TextEditingController(text: '');
  Firestore db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ImagePicker imagePicker = ImagePicker();
  List<String> listaDiaMesAnos = [];
  Usuario usuarioGlobal;

  String dataBanco;
  List<String> fotosBanco;

  RxBool _anexo = false.obs;

  RxBool _loading = false.obs;

  bool get loading => _loading.value;

  set loading(bool value) => _loading.value = value;

  bool get anexo => _anexo.value;

  set anexo(bool valor) => _anexo.value = valor;

  RxList _imagens = [].obs;
  List get imagens => _imagens.value;

  void onchangedAnexo(bool valor) {
    anexo = valor;

    if (!anexo) {
      _imagens.value = [];
    }
  }

  RxBool _isParcelado = false.obs;

  bool get isParcelado => _isParcelado.value;

  set isParcelado(bool value) => _isParcelado.value = value;

  RxBool _isPago = false.obs;

  bool get isPago => _isPago.value;

  set isPago(bool valor) => _isPago.value = valor;

  RxString _valor = ''.obs;

  String get valor => _valor.value;

  set valor(String valor) => _valor.value = valor;

  RxString _selecionadoCategoria = ''.obs;

  String get selecionadoCategoria => _selecionadoCategoria.value;

  set selecionadoCategoria(String categoria) =>
      _selecionadoCategoria.value = categoria;

  void onChagedParcelado(bool valor) {
    isParcelado = valor;
    //lancamento.qtdeParcela = lancamento.qtdeParcela ?? 0;
  }

  void onChangedCategoria(String value) {
    selecionadoCategoria = value;
    
  }

  //Fazer o set pra quando for edição de lancamentos
  void setarAll() {
    setarDataEditingController();
    setarQtdeParcelas();
    setarCategoria();
    setarBoolParcelado();
    setarBoolPAgo();
    setarDataAndFotos();
    setarAnexo();
    setarValor();
  }

  setarDataEditingController() {
    dataEditingController.text = lancamento.data;
  }

  setarQtdeParcelas(){
    parcelaEditingController.text = lancamento.qtdeParcela.toString();
  }

  void setarCategoria() {
    this.selecionadoCategoria = this.lancamento.categoria;
  }

  void setarBoolParcelado() {
    isParcelado = lancamento.parcelado;
  }

  void setarBoolPAgo() {
    isPago = lancamento.pago;
  }

  void setarDataAndFotos() {
    this.dataBanco = this.lancamento.data;
    this.fotosBanco = this.lancamento.fotos;
  }

  void setarAnexo() {
    anexo = this.fotosBanco.length > 0;
  }

  void setarValor() {
    if (lancamento.parcelado) {
      valor = 'R\$ ${MoedaUtil.formatarValor(lancamento.valorTotalParcelado)}';
    } else {
      valor = 'R\$ ${MoedaUtil.formatarValor(lancamento.valor)}';
    }
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

  String setarValorDespesa() {
    print('valor normal');
    print(lancamento.valor);
    print('valor parcelado');
    print(lancamento.valorTotalParcelado);
    return lancamento.parcelado
        ? lancamento.valorTotalParcelado == null
            ? ''
            : MoedaUtil.formatarValor(lancamento.valorTotalParcelado)
        : lancamento.valor == null
            ? ''
            : MoedaUtil.formatarValor(lancamento.valor);
  }

  List<DropdownMenuItem<String>> getCategorias() {
    return Categorias.getCategoriasDespesas();
  }

  void abrirDialogSelecionarFoto() {
    showDialog(
        context: Get.context,
        builder: (context) {
          return ElegantDialog(
            corDeFundo: corVermelha,
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

  Future<void> salvar() async {
    loading = true;

    if (selecionadoCategoria != '') {
      lancamento.parcelado = isParcelado;
      lancamento.data = dataEditingController.text;
      
      lancamento.categoria = selecionadoCategoria;
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

      salvarDadosNoBanco();
    } else {
      loading = false;
      Get.rawSnackbar(
          message: "Selecione uma categoria", backgroundColor: corVermelha);
    }
  }

  Future<void> salvarDadosNoBanco() async {
    FirebaseUser firebaseUser = await auth.currentUser();
    String anoMes = DataUtil.getAnoMes(lancamento.data);

    if (lancamento.parcelado) {
      lancamento.qtdeParcela = int.parse(parcelaEditingController.text);
      calcularParcelas(
          valor: double.parse(lancamento.valor),
          parcelas: lancamento.qtdeParcela,
          dataSelecionada: lancamento.data,
          idUsuario: firebaseUser.uid);
    } else {
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

    print('fechou o sucesso e deu tudo certo');
  }

  Future<void> calcularParcelas(
      {@required double valor,
      @required int parcelas,
      @required String dataSelecionada,
      @required String idUsuario}) async {
    dataSelecionada = DataUtil.getAnoMesDia(dataSelecionada);
    lancamento.valorTotalParcelado = lancamento.valor;

    DateTime data = DateTime.parse(dataSelecionada);

    double valorPorMes = valor / parcelas;

    for (int i = 0; i < parcelas; i++) {
      String diaMesAno = DateFormat('dd/MM/yyyy')
          .format(DateTime(data.year, data.month + i, data.day));
      String anoMes = DateFormat('yyyy-MM')
          .format(DateTime(data.year, data.month + i, data.day));

      lancamento.datasDespesasParceladas.add(anoMes);
      listaDiaMesAnos.add(diaMesAno);
      print('datas lancamento ${lancamento.datasDespesasParceladas}');
    }

    DocumentSnapshot documentSnapshot = await db
        .collection('usuarios')
        .document(idUsuario)
        .collection('lancamentos')
        .document('mes')
        .get();

    List<String> datasBanco = List<String>.from(documentSnapshot.data['datas']);
    List datas = [];

    if (datasBanco.isNotEmpty) {
      for (String anoMes in lancamento.datasDespesasParceladas) {
        if (!datasBanco.contains(anoMes)) {
          datas.add(anoMes);
        } else {
          continue;
        }
      }

      datas.addAll(datasBanco);
      print('datas completas $datas');

      datas.sort((a, b) => a.compareTo(b));
      print(datas);

      await db
          .collection('usuarios')
          .document(idUsuario)
          .collection('lancamentos')
          .document('mes')
          .setData({'datas': datas});
    } else {
      await db
          .collection('usuarios')
          .document(idUsuario)
          .collection('lancamentos')
          .document('mes')
          .setData({'datas': lancamento.datasDespesasParceladas});
    }

    for (int i = 1; i <= parcelas; i++) {
      if (i == parcelas) {
        double valorTotal =
            double.parse(valorPorMes.toStringAsFixed(2)) * parcelas;
        double excedente = valorTotal - valor;

        valorPorMes = valorPorMes - excedente;
      }

      salvarNoBancoEmParcelas(
          valorPorMes: valorPorMes,
          index: i,
          parcelas: parcelas,
          idUsuario: idUsuario);

      /*if (data.month == 2) {
        if (data.year % 4 == 0) {
          //Entra se o ano for bissexto
          data = data.add(Duration(days: 29));
        } else {
          //Entra se o ano não é bissexto

          data = data.add(Duration(days: 28));
        }
      } else if ([4, 6, 9, 11].contains(data.month)) {
        data = data.add(Duration(days: 30));
      } else {
        data = data.add(Duration(days: 31));
      }*/
    }

    await onSucesso();
  }

  Future<void> salvarNoBancoEmParcelas(
      {@required double valorPorMes,
      @required int index,
      @required int parcelas,
      @required String idUsuario}) async {
    lancamento.valor = valorPorMes.toStringAsFixed(2);
    lancamento.parcelasFaltantes = '$index/$parcelas';
    lancamento.data = listaDiaMesAnos[index - 1];

    String anoMes = lancamento.datasDespesasParceladas[index - 1];

    await db
        .collection('usuarios')
        .document(idUsuario)
        .collection('lancamentos')
        .document('mes')
        .collection(anoMes)
        .document(lancamento.idLancamento)
        .setData(lancamento.toMap());

    print('salvou $index vez(es)');
  }

  void editar() async {
    loading = true;
    if (selecionadoCategoria != '') {
      lancamento.parcelado = isParcelado;
      lancamento.data = dataEditingController.text;
      
      lancamento.categoria = selecionadoCategoria;
      FirebaseUser firebaseUser = await auth.currentUser();
      print('lista de imagens $imagens');
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

  Future<void> editarDadosNoBanco(FirebaseUser firebaseUser) async {
    print('fotos lancamento ${lancamento.fotos}');
    print('data do lancamento ${lancamento.data}');
    if (lancamento.parcelado) {
      lancamento.qtdeParcela = int.parse(parcelaEditingController.text);
      lancamentoParcelado(firebaseUser).then((value) {
        lancamento.datasDespesasParceladas = [];
        calcularParcelas(
            valor: double.parse(lancamento.valor),
            parcelas: lancamento.qtdeParcela,
            dataSelecionada: lancamento.data,
            idUsuario: firebaseUser.uid);
      });
    } else {
      lancamentoNaoParcelado(firebaseUser);
      //onSucesso();
    }
  }

  Future<void> lancamentoParcelado(FirebaseUser firebaseUser) async {
    DocumentSnapshot documentSnapshot = await db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('lancamentos')
        .document('mes')
        .get();

    List datas = [];
    datas = documentSnapshot.data['datas'];

    for (String data in lancamento.datasDespesasParceladas) {
      //Deletar cada mês
      await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .collection(data)
          .document(lancamento.idLancamento)
          .delete();
      //Verificar se ainda tem algum dado no mês

      QuerySnapshot querySnapshotDocuments = await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .collection(data)
          .getDocuments();
      //Se tiver, remover da lista
      if (querySnapshotDocuments.documents.length == 0) {
        datas.remove(data);
        print('dataaaaa $data');
        print('data removida');
      }
    }

    datas.sort((a, b) => a.compareTo(b));
    print('datas lancamento $datas');
    //atualizar listas de datas
    await db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('lancamentos')
        .document('mes')
        .setData({'datas': datas});
  }

  Future<void> lancamentoNaoParcelado(FirebaseUser firebaseUser) async {
    if (lancamento.qtdeParcela == null) {
      lancamento.qtdeParcela = 0;
    }
    if (lancamento.qtdeParcela > 1) {
      DocumentSnapshot documentSnapshot = await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .get();

      List datas = [];
      datas = documentSnapshot.data['datas'];

      for (String data in lancamento.datasDespesasParceladas) {
        //Deletar cada mês
        await db
            .collection('usuarios')
            .document(firebaseUser.uid)
            .collection('lancamentos')
            .document('mes')
            .collection(data)
            .document(lancamento.idLancamento)
            .delete();
        //Verificar se ainda tem algum dado no mês

        QuerySnapshot querySnapshotDocuments = await db
            .collection('usuarios')
            .document(firebaseUser.uid)
            .collection('lancamentos')
            .document('mes')
            .collection(data)
            .getDocuments();
        //Se tiver, remover da lista
        if (querySnapshotDocuments.documents.length == 0) {
          datas.remove(data);
        }
      }

      String anoMes = DataUtil.getAnoMes(lancamento.data);
      if (!datas.contains(anoMes)) {
        datas.add(anoMes);
      }

      datas.sort((a, b) => a.compareTo(b));
      print(datas);
      //atualizar listas de datas
      await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .setData({'datas': datas});

      //Inserir o novo dado no banco
      lancamento.datasDespesasParceladas = [];
      lancamento.parcelasFaltantes = null;
      lancamento.qtdeParcela = null;
      lancamento.valorTotalParcelado = null;
      await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .collection(anoMes)
          .document(lancamento.idLancamento)
          .setData(lancamento.toMap());
    } else {
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
        lancamento.qtdeParcela = null;
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
    if(editar){
      Get.back();
    }
    Get.back();

    Get.rawSnackbar(
        message: "Despesa Adicionada com Sucesso!", backgroundColor: corRoxa);
  }
}
