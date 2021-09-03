import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Lancamento {
  String idLancamento;
  String valor;
  String data;
  String tipo;
  String titulo;
  String descricao;
  List<String> fotos = [];
  String categoria;
  bool pago = false;
  bool parcelado = false;
  int qtdeParcela = 0;
  String parcelasFaltantes;
  String valorTotalParcelado;
  List<String> datasDespesasParceladas = [];
  List<String> nomeFotos = [];
  Lancamento({
    this.idLancamento,
    this.valor,
    this.data,
    this.tipo,
    this.titulo,
    this.descricao,
    this.fotos,
    this.categoria,
    this.pago,
    this.parcelado,
    this.qtdeParcela,
    this.parcelasFaltantes,
    this.valorTotalParcelado,
    this.datasDespesasParceladas,
    this.nomeFotos,
  });

  Lancamento.gerarId({@required this.tipo}) {
    Firestore db = Firestore.instance;

    this.idLancamento = db.collection('lancamentos').document().documentID;
    print(idLancamento);
  }

  Lancamento.fromJson(Map<String, dynamic> json) {
    this.idLancamento = json['idLancamento'];
    this.valor = json['valor'];
    this.data = json['data'];
    this.tipo = json['tipo'];
    this.titulo = json['titulo'];
    this.descricao = json['descricao'];
    this.fotos = List<String>.from(json['fotos'] ?? []);
    this.categoria = json['categoria'];
    this.pago = json['pago'];
    this.parcelado = json['parcelado'];
    this.qtdeParcela = json['qtdeParcela'];
    this.parcelasFaltantes = json['parcelasFaltantes'];
    this.valorTotalParcelado = json['valorTotalParcelado'];
    this.datasDespesasParceladas =
        List<String>.from(json['datasDespesasParceladas']);
    this.nomeFotos = List<String>.from(json['nomeFotos']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'idLancamento': this.idLancamento,
      'valor': this.valor,
      'data': this.data,
      'tipo': this.tipo,
      'titulo': this.titulo,
      'descricao': this.descricao,
      'fotos': this.fotos,
      'categoria': this.categoria,
      'pago': this.pago,
      'parcelado': this.parcelado,
      'qtdeParcela': this.qtdeParcela,
      'parcelasFaltantes': this.parcelasFaltantes,
      'valorTotalParcelado': this.valorTotalParcelado,
      'datasDespesasParceladas': this.datasDespesasParceladas,
      'nomeFotos': this.nomeFotos
    };

    return map;
  }

  @override
  String toString() {
    return 'Lancamento(idLancamento: $idLancamento, valor: $valor, data: $data, tipo: $tipo, titulo: $titulo, descricao: $descricao, fotos: $fotos, categoria: $categoria, pago: $pago, parcelado: $parcelado, qtdeParcela: $qtdeParcela, parcelasFaltantes: $parcelasFaltantes, valorTotalParcelado: $valorTotalParcelado, idLancamentosDespesas: $datasDespesasParceladas)';
  }
}
