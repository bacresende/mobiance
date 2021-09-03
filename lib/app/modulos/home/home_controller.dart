import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/widgets/elegant_button.dart';
import 'package:mobiance/app/widgets/elegant_dropdown.dart';
import 'package:mobiance/utils/categorias.dart';
import 'package:mobiance/utils/data_util.dart';
import 'package:mobiance/utils/generate_excel.dart';
import 'package:mobiance/utils/intervalo_datas.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:mobiance/utils/preferences.dart';

class HomeController extends GetxController {
  Firestore db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  GenerateExcel generateExcel = new GenerateExcel();
  DateTime dataAtual = DateTime.now();
  String mesAtual = '';
  RxString _mostrarMesAtual = ''.obs;
  RxBool _isFirst = false.obs;
  RxBool _isLast = false.obs;
  RxList lancamentos = [].obs;
  RxBool _isFront = true.obs;

  RxString balancoFuturo = "...".obs;
  RxString balancoMensal = "...".obs;

  RxBool balancoFuturoValido = true.obs;
  RxBool balancoMensalValido = true.obs;

  double valorReceitaMensal = 0;
  double valorDespesaMensal = 0;
  double valorTotalMensal = 0;

  RxList datas = [].obs;
  int index = 0;

  RxString _dataInicialSelecionada = ''.obs;
  RxString _dataFinalSelecionada = ''.obs;
  RxBool _mostrarCampoDataFinal = false.obs;

  List<String> listaIntervalada = [];
  List<String> datasIntervalo = [];

  List<Lancamento> lancamentosBalanco = [];

  String get mostrarMesAtual => _mostrarMesAtual.value;

  set mostrarMesAtual(String valor) => _mostrarMesAtual.value = valor;

  bool get isFirst => _isFirst.value;

  bool get isLast => _isLast.value;

  bool get isFront => _isFront.value;

  setIsFront() {
    _isFront.value = !_isFront.value;
  }

  String get dataInicialSelecionada => _dataInicialSelecionada.value;

  set dataInicialSelecionada(String value) =>
      _dataInicialSelecionada.value = value;

  String get dataFinalSelecionada => _dataFinalSelecionada.value;

  set dataFinalSelecionada(String value) => _dataFinalSelecionada.value = value;

  bool get mostrarCampoDataFinal => _mostrarCampoDataFinal.value;

  set mostrarCampoDataFinal(bool value) => _mostrarCampoDataFinal.value = value;

  bool get semLancamentos => this.lancamentos.value.isEmpty;

  @override
  void onInit() async {
    super.onInit();
    print('----------------------entrou no on init---------------------');
    FirebaseUser firebaseUser = await auth.currentUser();
    db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('lancamentos')
        .document('mes')
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data != null) {
        mesAtual = DateFormat('yyyy-MM').format(dataAtual);

        datas.value = documentSnapshot.data['datas'] ?? [];
        if (datas.isNotEmpty) {
          if (datas.contains(mesAtual)) {
            this.index = datas.value.indexOf(mesAtual);
          } else {
            this.index = ((datas.length / 2).round() - 1);
          }

          if (this.index == (datas.length - 1)) {
            _isLast.value = true;
          }

          if (this.index == 0) {
            _isFirst.value = true;
          }

          if (datas.length == 1) {
            _isLast.value = true;
            _isFirst.value = true;
          }
          acessarBanco();
          print('datas on init ${datas.value}');

          somarBalancoFuturo();
        }
      } else {
        mostrarMesAtual = 'Sem Lançamentos';
        _isLast.value = true;
        _isFirst.value = true;
      }
    });
  }

  Future<void> somarBalancoFuturo() async {
    this.lancamentosBalanco.clear();
    FirebaseUser firebaseUser = await auth.currentUser();
    double valor = 0;

    List datasLocal = List<String>.from(datas.value);
    print('datas local $datasLocal');

    if (datasLocal.isNotEmpty) {
      print('index global ${this.index}');
      for (int i = 0; i <= this.index; i++) {
        datasLocal.removeAt(0);
      }
      print('datas local $datasLocal');
    }

    for (String data in datasLocal) {
      QuerySnapshot querySnapshot = await db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .collection(data)
          .getDocuments();

      for (DocumentSnapshot doc in querySnapshot.documents) {
        Lancamento lancamento = Lancamento.fromJson(doc.data);
        this.lancamentosBalanco.add(lancamento);
        if (lancamento.tipo == 'r') {
          valor += double.parse(lancamento.valor);
        } else {
          valor -= double.parse(lancamento.valor);
        }
      }
    }

    balancoFuturo.value = 'R\$ ${MoedaUtil.formatarValor(valor.toString())}';

    balancoFuturoValido.value = valor >= 0;

    print(valor);
  }

  void abrirDialogBalancoMensal() {
    String mesAno = DataUtil.getMostrarMesAtual(datas.value[this.index]);
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: ListTile(
                      title: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                mesAno,
                                style: TextStyle(
                                    color: corRoxa,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Divider()
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Receita: R\$ ${MoedaUtil.formatarValor(this.valorReceitaMensal.toString())}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: corVerde,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Despesa: R\$ ${MoedaUtil.formatarValor(this.valorDespesaMensal.toString())}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: corVermelha,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total',
                                style: flatButtonRoxoStyle,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'R\$ ${MoedaUtil.formatarValor(this.valorTotalMensal.toString())}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: this.valorTotalMensal >= 0
                                        ? corVerde
                                        : corVermelha,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.grey[200],
                        size: 100,
                      ),
                    ),
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

  void abrirDialogIntervaloExcel() {
    String mesAno = DataUtil.getMostrarMesAtual(datas.value[this.index]);
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
                            'Selecione o que deseja gerar',
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
                    title: Text('Gerar Excel do Mês em Questão',
                        style: TextStyle(
                            color: corRoxa,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '($mesAno)',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      print('mes em questao');
                      Get.back();
                      Get.back();
                      String dataSelecionada = this.datas[this.index];
                      String mesAnoFormatado = DataUtil.getMostrarMesAtual(
                          dataSelecionada,
                          isExcel: true);
                      generateExcel
                          .createExcel([dataSelecionada], mesAnoFormatado);
                    },
                  ),
                  Divider(
                    color: corRoxa,
                  ),
                  ListTile(
                    title: Text('Gerar Excel em um Intervalo de Tempo',
                        style: TextStyle(
                            color: corRoxa,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '(De uma data à outra)',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      abrirDialogIntervaloInicialExcel();
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

  void abrirDialogIntervaloInicialExcel() {
    this.listaIntervalada = [];
    this.datasIntervalo = [];
    this.dataInicialSelecionada = null;
    this.dataFinalSelecionada = null;
    this.mostrarCampoDataFinal = false;

    showModalBottomSheet(
        context: Get.context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Obx(() => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, bottom: 10),
                              child: Text(
                                'Selecione o Primeiro Intervalo',
                                style: TextStyle(
                                    color: corRoxa,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            ElegantDropdown(
                              cor: corRoxa,
                              value: this.dataInicialSelecionada ?? null,
                              hint: 'Selecione a primera data',
                              items:
                                  IntervaloDatas.getDatasIniciais(this.datas),
                              onChanged: onChangedDataInicial,
                            ),
                          ],
                        ),
                        mostrarCampoDataFinal
                            ? SizedBox(
                                height: 20,
                                child: Divider(color: corRoxa),
                              )
                            : Container(),
                        mostrarCampoDataFinal
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, bottom: 10),
                                    child: Text(
                                      'Selecione o Segundo Intervalo',
                                      style: TextStyle(
                                          color: corRoxa,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  ElegantDropdown(
                                    cor: corRoxa,
                                    value: this.dataFinalSelecionada ?? null,
                                    hint: 'Selecione a segunda data',
                                    items: IntervaloDatas.getDatasFinais(
                                        datasIntervalo),
                                    onChanged: onChangedDatafinal,
                                  ),
                                ],
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 16, bottom: 10, left: 8, right: 8),
                          child: ElegantButton(
                            color: corRoxa,
                            label: 'Gerar Excel',
                            action: () {
                              print(listaIntervalada);
                              String mesAnoInicial =
                                  DataUtil.getMostrarMesAtual(
                                      listaIntervalada.first,
                                      isExcel: true);
                              String mesAnoFinal = DataUtil.getMostrarMesAtual(
                                  listaIntervalada.last,
                                  isExcel: true);

                              String intervalo =
                                  '$mesAnoInicial à $mesAnoFinal';
                              Get.back();
                              Get.back();
                              Get.back();
                              generateExcel.createExcel(
                                  listaIntervalada, intervalo);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        });
  }

  void onChangedDataInicial(String value) {
    this.dataInicialSelecionada = value;
    datasIntervalo = List.from(this.datas);

    int index = datasIntervalo.indexOf(this.dataInicialSelecionada);

    for (int i = 0; i <= index; i++) {
      datasIntervalo.removeAt(0);
    }

    mostrarCampoDataFinal = true;
    this.dataFinalSelecionada = null;
  }

  void onChangedDatafinal(String value) {
    listaIntervalada.clear();
    this.dataFinalSelecionada = value;

    int index = datasIntervalo.indexOf(this.dataFinalSelecionada);

    for (int i = 0; i <= index; i++) {
      listaIntervalada.add(datasIntervalo[i]);
    }

    listaIntervalada.insert(0, this.dataInicialSelecionada);
  }

  Future<void> recarregar() async {
    print('----------------------entrou no recarregar---------------------');
    FirebaseUser firebaseUser = await auth.currentUser();
    DocumentSnapshot documentSnapshot = await db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('lancamentos')
        .document('mes')
        .get();

    mesAtual = DateFormat('yyyy-MM').format(dataAtual);
    datas.value =
        documentSnapshot.data != null ? documentSnapshot.data['datas'] : [];
    if (datas.isNotEmpty) {
      if (datas.contains(mesAtual)) {
        this.index = datas.value.indexOf(mesAtual);
      } else {
        this.index = ((datas.length / 2).round() - 1);
      }

      if (this.index == 0) {
        _isFirst.value = true;
      }

      if (datas.length == 1) {
        _isLast.value = true;
        _isFirst.value = true;
      }
      acessarBanco();
    } else {
      Get.rawSnackbar(
          title: 'Sem lançamentos no momento',
          message: ' ',
          backgroundColor: corRoxa);
    }
  }

  Future<void> acessarBanco() async {
    this.valorReceitaMensal = 0;
    this.valorDespesaMensal = 0;
    this.valorTotalMensal = 0;
    FirebaseUser firebaseUser = await auth.currentUser();

    String anoMes = datas.value[this.index];

    this.mostrarMesAtual = DataUtil.getMostrarMesAtual(anoMes);

    db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('lancamentos')
        .document('mes')
        .collection(anoMes)
        .snapshots()
        .listen((querySnapshot) {
      List<Lancamento> lancamentosTemp = querySnapshot.documents
          .map((DocumentSnapshot documentSnapshot) =>
              Lancamento.fromJson(documentSnapshot.data))
          .toList();
      lancamentosTemp
          .sort((Lancamento a, Lancamento b) => b.data.compareTo(a.data));

      lancamentos.value = [];
      lancamentos.addAll(lancamentosTemp);
      double valor = 0;
      for (Lancamento lancamento in lancamentos) {
        if (lancamento.tipo == 'r') {
          valor += double.parse(lancamento.valor);
          this.valorReceitaMensal += double.parse(lancamento.valor);
        } else {
          valor -= double.parse(lancamento.valor);
          this.valorDespesaMensal += double.parse(lancamento.valor);
        }

        balancoMensal.value =
            'R\$ ${MoedaUtil.formatarValor(valor.toString())}';

        balancoMensalValido.value = valor >= 0;

        this.valorTotalMensal =
            this.valorReceitaMensal - this.valorDespesaMensal;
      }
    });
  }

  void avancarLancamento() {
    this.index++;
    _isLast.value = (datas.length - 1) == this.index;
    _isFirst.value = this.index == 0;

    acessarBanco();
    somarBalancoFuturo();
  }

  void retrocederLancamento() {
    this.index--;
    _isLast.value = false;
    _isFirst.value = this.index == 0;

    acessarBanco();
    somarBalancoFuturo();
  }

  void abrirDialogAno() {
    List<String> anos = [];
    for (String anoMes in datas) {
      String ano = anoMes.split('-')[0];
      anos.add(ano);
    }
    anos = anos.toSet().toList();
    showDialog(
        context: Get.context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: Card(
                      color: corRoxa,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Selecione o Ano',
                              style: TextStyle(
                                  color: corBranca,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: anos.length,
                    itemBuilder: (context, i) {
                      String ano = anos[i];

                      return ListTile(
                        title: Text(
                          ano,
                          style: TextStyle(
                              color: corRoxa,
                              fontSize: 22,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          List<String> anosCompleto = [];

                          for (String data in datas) {
                            String dataLocal = data.split('-')[0];
                            print('data $data - dataLocal $dataLocal');

                            if (dataLocal == ano) {
                              anosCompleto.add(data);
                            }
                          }
                          print(anosCompleto);
                          abrirDialogAnoMes(anosCompleto);
                        },
                      );
                    },
                  )),
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

  void abrirDialogAnoMes(List<String> anosCompletos) {
    showDialog(
        context: Get.context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: Card(
                      color: corRoxa,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Selecione o Mês',
                              style: TextStyle(
                                  color: corBranca,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: anosCompletos.length,
                    itemBuilder: (context, i) {
                      String data = anosCompletos[i];

                      return ListTile(
                        title: Text(
                          '${DataUtil.getMostrarMesAtual(data)}',
                          style: TextStyle(
                              color: corRoxa,
                              fontSize: 18,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          this.index = datas.value.indexOf(data);

                          _isFirst.value = this.index == 0;
                          _isLast.value = this.index == (datas.length - 1);

                          acessarBanco();
                          somarBalancoFuturo();

                          Get.back();
                          Get.back();
                        },
                      );
                    },
                  )),
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

  bool get isLancamentoAtual => datas.contains(mesAtual);

  void irParaDataAtual() {
    _isLast.value = false;
    _isFirst.value = false;

    this.index = datas.value.indexOf(mesAtual);
    if (this.index == 0) {
      _isFirst.value = true;
    }

    if (this.index == (datas.length - 1)) {
      _isLast.value = true;
    }
    acessarBanco();
    somarBalancoFuturo();

    Get.rawSnackbar(
      message: 'Data Atual',
      backgroundColor: corRoxa,
    );
  }

  void setarValoresBalancos() {
    this.valorReceitaMensal = 0;
    this.valorDespesaMensal = 0;
    this.valorTotalMensal = 0;
  }
}
