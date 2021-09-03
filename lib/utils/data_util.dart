class DataUtil {
  static String getAnoMes(String data) {
    List<String> diaMesAno = data.split('/');
    String anoMes = diaMesAno[2] + '-' + diaMesAno[1];
    return anoMes;
  }

  static String getAnoMesDia(String data) {
    List<String> listaData = data.split('/');
    String anoMesDia = listaData[2] + listaData[1] + listaData[0];
    return anoMesDia;
  }

  static bool isValidDate(String input) {
    final date = DateTime.parse(input);
    final originalFormatString = toOriginalFormatString(date);
    return input == originalFormatString;
  }

  static String toOriginalFormatString(DateTime dateTime) {
    final a = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$a$m$d";
  }

  static String getMesAbreviado(String mes) {
    String mesAbrv;
    switch (mes) {
      case '01':
        mesAbrv = 'JAN';  
        break;
      case '02':
        mesAbrv = 'FEV';
        break;
      case '03':
        mesAbrv = 'MAR';
        break;
      case '04':
        mesAbrv = 'ABR';
        break;
      case '05':
        mesAbrv = 'MAI';
        break;
      case '06':
        mesAbrv = 'JUN';
        break;
      case '07':
        mesAbrv = 'JUL';
        break;
      case '08':
        mesAbrv = 'AGO';
        break;
      case '09':
        mesAbrv = 'SET';
        break;
      case '10':
        mesAbrv = 'OUT';
        break;
      case '11':
        mesAbrv = 'NOV';
        break;
      case '12':
        mesAbrv = 'DEZ';
        break;
    }

    return mesAbrv;
  }

  static String getMostrarMesAtual(String anoMes, {bool isExcel = false}) {
    List<String> listaAnoMes = anoMes.split('-');
    String mes = getMesAbreviado(listaAnoMes[1]);

    if(isExcel){
      mes = listaAnoMes[1];
    }

    return mes + '/' + listaAnoMes[0];
  }
}
