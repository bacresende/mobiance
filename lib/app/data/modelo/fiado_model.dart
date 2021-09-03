import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:mobiance/utils/preferences.dart';

class FiadoModel {
  String nome;
  String id;
  String tipoEmprestimo;
  String valorTotal;
  String valorPago;
  String descricao;
  String data;
  List<String> pagamentos = [];

  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  FiadoModel();

  FiadoModel.fromDocumentOpcoes(DocumentSnapshot documentSnapshot) {
    this.nome = documentSnapshot.data['nome'];
    this.id = documentSnapshot.documentID;
  }

  FiadoModel.fromDocumentDataBase(DocumentSnapshot documentSnapshot) {
    this.nome = documentSnapshot.data['nome'];
    this.id = documentSnapshot.documentID;
    this.tipoEmprestimo = documentSnapshot.data['tipoEmprestimo'];
    this.valorTotal = documentSnapshot.data['valorTotal'];
    this.valorPago = documentSnapshot.data['valorPago'];
    this.descricao = documentSnapshot.data['descricao'];
    this.data = documentSnapshot.data['data'];
  }

  bool get isEmprestei => this.tipoEmprestimo == 'Eu Emprestei';

  double get porcentagem =>
      double.parse(this.valorPago) / double.parse(this.valorTotal);

  bool get isVencido {
    DateTime dataAtual = DateTime.now();
    DateTime dataBanco = getDataConvertida();
    print(dataAtual.isAfter(dataBanco));
    return dataAtual.isAfter(dataBanco);
  }

  DateTime getDataConvertida() {
    List<String> diaMesAnoBancoList = this.data.split('/');
    int dia = int.parse(diaMesAnoBancoList[0]);
    int mes = int.parse(diaMesAnoBancoList[1]);
    int ano = int.parse(diaMesAnoBancoList[2]);
    return DateTime(ano, mes, dia);
  }

  bool get temDescricao => this.descricao != null;

  String get subtrairTotalDoValorPago =>
      (double.parse(valorTotal) - double.parse(valorPago)).toString();

  Future<void> salvar() async {
    FirebaseUser firebaseUser = await _auth.currentUser();

      await _db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('emprestimos')
          .add(toMap());
    

    print(toMap());
  }

  Future<void> atualizarValorPagoNoBanco(String valorPagoDigitado) async {
    double valorTotalPago =
        double.parse(valorPago) + double.parse(valorPagoDigitado);

    if (valorTotalPago <= double.parse(valorTotal)) {
      FirebaseUser firebaseUser = await _auth.currentUser();
      _db
          .collection('usuarios')
          .document(firebaseUser.uid)
          .collection('emprestimos')
          .document(id)
          .updateData({'valorPago': valorTotalPago.toString()});
      Get.back();
      if (valorTotalPago == double.parse(valorTotal)) {
        
        await deletarEmprestimo();
        Get.rawSnackbar(
            title: 'Empréstimo Finalizado!',
            message: isEmprestei
                ? '$nome terminou de pagar você'
                : 'Você terminou de pagar $nome',
            backgroundColor: corVerde);
      }
    } else {
      Get.rawSnackbar(
          title: 'O valor pago, é maior que o valor total',
          message:
              "Digite um valor de até R\$ ${MoedaUtil.formatarValor(subtrairTotalDoValorPago)}",
          backgroundColor: corVermelha);
    }
    print('valor total $valorTotalPago');
  }

  Future<void> deletarEmprestimo() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    _db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('emprestimos')
        .document(id)
        .delete();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toMap = {
      'nome': this.nome,
      'tipoEmprestimo': this.tipoEmprestimo,
      'valorTotal': this.valorTotal,
      'valorPago': '0',
      'descricao': this.descricao,
      'data': this.data,
    };

    return toMap;
  }
}
