import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/balanco_total_mensal.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';

class BalancoFuturoController extends GetxController {
  HomeController homeController = Get.find();
  List<String> datas = [];
  List<BalancoTotalMensal> balancos = [];

  void pegarMeses() {
    List<Lancamento> lancamentos = homeController.lancamentosBalanco;

    for (Lancamento lancamento in lancamentos) {
      String data = lancamento.data;
      List<String> diaMesAno = data.split('/');
      String mesAno = diaMesAno[1] + '/' + diaMesAno[2];

      datas.add(mesAno);
    }
    datas = datas.toSet().toList();

    
    for (String data in datas) {
      balancos.add(new BalancoTotalMensal());
    }

    print(balancos);

    for (int i = 0; i < datas.length; i++) {
      for (Lancamento lancamento in lancamentos) {
        String data = lancamento.data;
        List<String> diaMesAno = data.split('/');
        String mesAno = diaMesAno[1] + '/' + diaMesAno[2];

        if (datas[i] == mesAno) {
          BalancoTotalMensal balancoTotalMensal = balancos[i];
          balancoTotalMensal.data = datas[i];
          if (lancamento.tipo == 'r') {
            balancoTotalMensal.receita += double.parse(lancamento.valor);
            balancoTotalMensal.total += double.parse(lancamento.valor);
          } else {
            balancoTotalMensal.despesa += double.parse(lancamento.valor);
            balancoTotalMensal.total -= double.parse(lancamento.valor);
          }
        }
      }
    }
  }
}
