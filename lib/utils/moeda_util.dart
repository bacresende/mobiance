import 'package:intl/intl.dart';

class MoedaUtil{
  // Formata o valor informado na formatação pt/BR
  static String formatarValor(String valor){
    double recebeValor = double.parse(valor);
    NumberFormat numberFormat = new NumberFormat("#,##0.00", "pt_BR");
    return numberFormat.format(recebeValor);
  }
}