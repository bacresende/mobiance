import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GeneratePDF {
  Usuario usuario;
  List lista;
  double totalReceita = 0;
  double totalDespesa = 0;
  double total = 0;
  DateTime dataAtual = DateTime.now();
  GeneratePDF({@required this.usuario, this.lista}) {
    setarValores();
  }
  PdfImage profileImage;

  /// Cria e Imprime a fatura
  Future<void> generatePDFInvoice() async {
    final pw.Document doc = pw.Document();
    // final pw.Font customFont =
    //     pw.Font.ttf((await rootBundle.load('assets/RobotoSlabt.ttf')));
    profileImage = PdfImage.file(
      doc.document,
      bytes: (await rootBundle.load('assets/dev_assets/logo.jpg'))
          .buffer
          .asUint8List(),
    );
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: pw.EdgeInsets.zero,
        ),
        // theme:
        //     pw.ThemeData(defaultTextStyle: pw.TextStyle(font: customFont))),
        header: _buildHeader,
        footer: _buildPrice,
        build: (context) => _buildContent(context),
      ),
    );
    await Printing.layoutPdf(
      name: 'Mobiance . ${DateFormat('dd/MM/yyyy').format(dataAtual)}',
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  /// Constroi o cabeçalho da página
  pw.Widget _buildHeader(pw.Context context) {
    return pw.Container(
        color: PdfColors.purple800,
        height: 100,
        // width: double.infinity,
        child: pw.Padding(
            padding: pw.EdgeInsets.all(16),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  //indica primeira logo do lado esquerdo do pdf
                  //Não sei qual o motivo de a logo ficar escura após salvar o pdf
                  /*
                  pw.Container(
                    width: 50,
                    height: 50,
                    decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(
                            image: pw.Image(profileImage).image,
                            fit: pw.BoxFit.fill)),
                  ),
                  pw.SizedBox(width: 10),*/

                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Text('Mobiance',
                          style: pw.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pw.Text('Despesas/Receitas',
                          style: pw.TextStyle(color: PdfColors.white)),
                    ],
                  ),
                  _buildData()
                ])));
  }

  /// Constroi o conteúdo da página
  List<pw.Widget> _buildContent(pw.Context context) {
    return [
      _contentTable(context),
    ];
  }

  pw.Widget _buildData() {
    
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        _titleText('Gerado em'),
        pw.Text(
            DateFormat('dd/MM/yyyy').format(dataAtual) +
                ' às ' +
                DateFormat('HH:mm').format(dataAtual),
            style: pw.TextStyle(color: PdfColors.white))
        // pw.Text(.client.name),
        //_titleText('Endereço'),
        // pw.Text(invoice.client.address)
      ],
    );
  }

  /// Retorna um texto com formatação própria para título
  pw.Widget _titleText(String text) {
    return pw.Padding(
        padding: pw.EdgeInsets.only(top: 8),
        child: pw.Text(text,
            style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white)));
  }

  /// Constroi uma tabela com base nos produtos da fatura
  pw.Widget _contentTable(pw.Context context) {
    // Define uma lista usada no cabeçalho
    const tableHeaders = [
      'Data',
      'Título',
      'Descrição',
      'Categoria',
      'Preço',
      'Parcelas',
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: 2,
      ),
      headerHeight: 25,
      cellHeight: 40,
      // Define o alinhamento das células, onde a chave é a coluna
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center
      },
      // Define um estilo para o cabeçalho da tabela
      headerStyle: pw.TextStyle(
        fontSize: 10,
        color: PdfColors.purple800,
        fontWeight: pw.FontWeight.bold,
      ),
      // Define um estilo para a célula
      cellStyle: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.black,
            ),
      // Define a decoração
      rowDecoration: pw.BoxDecoration(
        border: pw.BoxBorder(
          bottom: true,
          color: PdfColors.purple800,
          width: .5,
        ),
      ),
      headers: tableHeaders,
      // retorna os valores da tabela, de acordo com a linha e a coluna
      data: List<List<String>>.generate(
        lista.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => _getValueIndex(lista[row], col),
        ),
      ),
    );
  }

  /// Retorna o valor correspondente a coluna
  String _getValueIndex(Lancamento lancamento, int col) {
    switch (col) {
      case 0:
        return lancamento.data;
      case 1:
        return lancamento.titulo;
      case 2:
        return lancamento.descricao ?? ".";
      case 3:
        return lancamento.categoria;
      case 4:
        return lancamento.tipo == "r"
            ? " R\$ ${MoedaUtil.formatarValor(lancamento.valor)}"
            : "- R\$ ${MoedaUtil.formatarValor(lancamento.valor)}";
      case 5:
        return lancamento.parcelasFaltantes ?? '.';
    }
    return '';
  }

  /// Retorna o QrCode da fatura
  pw.Widget _buildQrCode(pw.Context context) {
    return pw.Container(
        height: 65,
        width: 65,
        child: pw.BarcodeWidget(
            barcode: pw.Barcode.fromType(pw.BarcodeType.QrCode),
            data: 'invoice_id=001',
            color: PdfColors.white));
  }

  /// Retorna o rodapé da página
  pw.Widget _buildPrice(pw.Context context) {
    return pw.Container(
      color: PdfColors.purple800,
      height: 100,
      child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            /*pw.Padding(
                padding: pw.EdgeInsets.only(left: 16),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      _buildQrCode(context),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(top: 12),
                          child: pw.Text('Use esse QR para pagar',
                              style: pw.TextStyle(
                                  color: PdfColor(0.85, 0.85, 0.85))))
                    ])),*/
            pw.Padding(
                padding: pw.EdgeInsets.all(16),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                          'Receitas: R\$: ${MoedaUtil.formatarValor(totalReceita.toString())} ',
                          style: pw.TextStyle(color: PdfColors.white)),
                      pw.Text(
                          'Despesas: R\$: ${MoedaUtil.formatarValor(totalDespesa.toString())} ',
                          style: pw.TextStyle(color: PdfColors.white)),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(top: 8),
                          child: pw.Text(
                              'Total: R\$: ${MoedaUtil.formatarValor(total.toString())} ',
                              style: pw.TextStyle(
                                  color: PdfColors.white, fontSize: 20)))
                    ]))
          ]),
    );
  }

  void setarValores() {
    for (Lancamento lancamento in lista) {
      if (lancamento.tipo == "r") {
        double valor = double.parse(lancamento.valor);
        this.totalReceita += valor;
      } else {
        double valor = double.parse(lancamento.valor);
        this.totalDespesa += valor;
      }
    }

    this.total = this.totalReceita - this.totalDespesa;
  }
}
