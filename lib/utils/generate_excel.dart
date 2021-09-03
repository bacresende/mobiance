import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart' as open_file;

import '../app/data/modelo/usuario.dart';

class GenerateExcel {
  Worksheet sheet;
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, double> mapGlobal = {};
  double receitas = 0;
  double despesas = 0;

  Future<void> createExcel(List<String> datas, String intervalo) async {
    this.receitas = 0;
    this.despesas = 0;
    print('excel mob $datas');

    FirebaseUser firebaseUser = await _auth.currentUser();
    List<Lancamento> lancamentos = [];
    List<Lancamento> lancamentosDespesas = [];
    List<Lancamento> lancamentosReceitas = [];

    //Pegar os dados do banco
    for (String anoMes in datas) {
      QuerySnapshot querySnapshot = await _db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('lancamentos')
          .document('mes')
          .collection(anoMes)
          .getDocuments();

      for (DocumentSnapshot document in querySnapshot.documents) {
        Lancamento lancamento = new Lancamento.fromJson(document.data);
        lancamentos.add(lancamento);
      }

      print(lancamentos);
    }

    //Verificar se é despesa ou receita
    for (Lancamento lancamento in lancamentos) {
      if (lancamento.tipo == 'd') {
        lancamentosDespesas.add(lancamento);
        this.despesas += double.parse(lancamento.valor);
      } else {
        lancamentosReceitas.add(lancamento);
        this.receitas += double.parse(lancamento.valor);
      }
    }

    lancamentos.clear();
    lancamentos.addAll(lancamentosDespesas);
    lancamentos.addAll(lancamentosReceitas);

    print('lançamento ordenados $lancamentos');

    Map<String, double> map = {};

    for (Lancamento lancamento in lancamentos) {
      String categoria = lancamento.categoria;
      String valor = lancamento.valor;

      if (map[categoria] != null) {
        map[categoria] += double.parse(valor);
      } else {
        map[categoria] = double.parse(valor);
      }
    }

    this.mapGlobal = map;
    print(map);

    //Create an Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();

    //Accessing via index
    sheet = workbook.worksheets[0];
    configuracoesIniciais(intervalo.toLowerCase());

    colunaCategoria();
    colunaValor();

    celulasResultadosTotais();

    rodape();

    //TODO: FALTA FAZER, PACKAGE DANDO ERRO
    //graficos();

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Get the storage folder location using path_provider package.
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/output.xlsx');
    await file.writeAsBytes(bytes);

    //Launch the file (used open_file package)
    await open_file.OpenFile.open('$path/output.xlsx');
  }

  void graficos() {
    //Falta fazer, package dando erro
  }

  void rodape() {
    int linhaRodape = this.mapGlobal.length + 24;
    sheet
        .getRangeByName('A$linhaRodape')
        .setText('Obrigado por fazer parte do Mobiance <3');
    sheet.getRangeByName('A$linhaRodape').cellStyle.fontSize = 8;
    sheet.getRangeByName('A$linhaRodape').cellStyle.fontColor = '#ffffff';

    final Range range9 =
        sheet.getRangeByName('A$linhaRodape:H${linhaRodape + 1}');
    range9.cellStyle.backColor = '#4e0080';
    range9.merge();
    range9.cellStyle.hAlign = HAlignType.center;
    range9.cellStyle.vAlign = VAlignType.center;
  }

  void linhasRoxas(String celulas) {
    Range rangeTop = sheet.getRangeByName(celulas);

    rangeTop.cellStyle.backColor = '#4e0080';
    rangeTop.merge();
  }

  void colunaCategoria() {
    sheet.getRangeByName('B13').setText('Categoria');
    sheet.getRangeByName('B13').cellStyle.fontColor = '#4e0080';
    sheet.getRangeByName('B13').cellStyle.bold = true;

    for (int i = 0; i < this.mapGlobal.length; i++) {
      int linha = i + 14;
      sheet.getRangeByName('B$linha').setText(this.mapGlobal.keys.toList()[i]);
    }
  }

  void colunaValor() {
    sheet.getRangeByName('C13').setText('Preço');
    sheet.getRangeByName('C13').cellStyle.fontColor = '#4e0080';
    sheet.getRangeByName('C13').cellStyle.bold = true;

    for (int i = 0; i < this.mapGlobal.length; i++) {
      int linha = i + 14;
      sheet.getRangeByName('C$linha').setText('R\$ ' +
          MoedaUtil.formatarValor(
              this.mapGlobal.values.toList()[i].toString()));
      sheet.getRangeByName('C$linha:D$linha').merge();
    }
  }

  void celulasResultadosTotais() {
    int linhaReceita = this.mapGlobal.length + 15;
    sheet.getRangeByName('B$linhaReceita').setText('Receitas');
    sheet.getRangeByName('B$linhaReceita').cellStyle.fontColor = '#49B675';

    sheet
        .getRangeByName('C$linhaReceita')
        .setText('R\$ ${MoedaUtil.formatarValor(this.receitas.toString())}');
    sheet.getRangeByName('C$linhaReceita').cellStyle.fontColor = '#49B675';
    sheet.getRangeByName('C$linhaReceita:D$linhaReceita').merge();

    //---------------------------------------------------------------------//

    int linhaDespesa = this.mapGlobal.length + 16;
    sheet.getRangeByName('B$linhaDespesa').setText('Despesas');
    sheet.getRangeByName('B$linhaDespesa').cellStyle.fontColor = '#AB2E46';

    sheet
        .getRangeByName('C$linhaDespesa')
        .setText('R\$ ${MoedaUtil.formatarValor(this.despesas.toString())}');
    sheet.getRangeByName('C$linhaDespesa').cellStyle.fontColor = '#AB2E46';
    sheet.getRangeByName('C$linhaDespesa:D$linhaDespesa').merge();

    //---------------------------------------------------------------------//

    int linhaTotal = this.mapGlobal.length + 18;
    double total = this.receitas - this.despesas;
    sheet.getRangeByName('B$linhaTotal').setText('Total');
    sheet.getRangeByName('B$linhaTotal').cellStyle.bold = true;
    sheet.getRangeByName('B$linhaTotal').cellStyle.fontSize = 15;
    sheet.getRangeByName('B$linhaTotal:B${linhaTotal + 1}').merge();

    sheet
        .getRangeByName('C$linhaTotal')
        .setText('R\S ${MoedaUtil.formatarValor(total.toString())}');
    sheet.getRangeByName('C$linhaTotal').cellStyle.bold = true;
    sheet.getRangeByName('C$linhaTotal').cellStyle.fontSize = 18;
    sheet.getRangeByName('C$linhaTotal:D${linhaTotal + 1}').merge();

    sheet.getRangeByName('B$linhaTotal').cellStyle.fontColor = '#49B675';
    sheet.getRangeByName('C$linhaTotal').cellStyle.fontColor = '#49B675';

    if (total < 0) {
      sheet.getRangeByName('B$linhaTotal').cellStyle.fontColor = '#AB2E46';
      sheet.getRangeByName('C$linhaTotal').cellStyle.fontColor = '#AB2E46';
    }
  }

  void configuracoesIniciais(String intervalo) {
    Usuario usuario = GetStorage().read('usuario');

    sheet.showGridlines = false;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    sheet.getRangeByName('A1:H1').cellStyle.backColor = '#4e0080';
    sheet.getRangeByName('A1:H1').merge();
    sheet.getRangeByName('B4:D6').merge();

    sheet.getRangeByName('B4').setText('Mobiance');
    sheet.getRangeByName('B4').cellStyle.fontSize = 32;
    sheet.getRangeByName('B4').cellStyle.fontColor = '#4e0080';

    sheet.getRangeByName('B8').setText('Gerado por:');
    sheet.getRangeByName('B8').cellStyle.fontSize = 9;
    sheet.getRangeByName('B8').cellStyle.bold = true;

    sheet.getRangeByName('B9').setText(usuario.nome);
    sheet.getRangeByName('B9').cellStyle.fontSize = 12;

    final Range range1 = sheet.getRangeByName('F8:G8');
    final Range range2 = sheet.getRangeByName('F9:G9');
    final Range range3 = sheet.getRangeByName('F10:G10');
    final Range range4 = sheet.getRangeByName('F11:G11');
    final Range range5 = sheet.getRangeByName('F12:G12');

    range1.merge();
    range2.merge();
    range3.merge();
    range4.merge();
    range5.merge();

    sheet.getRangeByName('F8').setText('Interrvalo de:');
    range1.cellStyle.fontSize = 8;
    range1.cellStyle.bold = true;
    range1.cellStyle.hAlign = HAlignType.right;

    sheet.getRangeByName('F9').setText(intervalo);
    range2.cellStyle.fontSize = 9;
    range2.cellStyle.hAlign = HAlignType.right;

    sheet.getRangeByName('F10').setText('Gerado em:');
    range3.cellStyle.fontSize = 8;
    range3.cellStyle.bold = true;
    range3.cellStyle.hAlign = HAlignType.right;

    sheet.getRangeByName('F11').dateTime = DateTime.now();
    sheet.getRangeByName('F11').numberFormat = 'dd/mm/yyyy';
    range4.cellStyle.fontSize = 9;
    range4.cellStyle.hAlign = HAlignType.right;

    range5.cellStyle.fontSize = 8;
    range5.cellStyle.bold = true;
    range5.cellStyle.hAlign = HAlignType.right;
  }
}
