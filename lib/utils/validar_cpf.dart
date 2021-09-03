class ValidarCPF {
  static int num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11;
  static int soma1, soma2;
  static var resto1, resto2;

  static bool isCpfValidado(String cpf) {
    cpf = cpf.replaceAll('.', '').replaceAll('-', '');
    
    num1 = int.parse(cpf.substring(0, 1));
    num2 = int.parse(cpf.substring(1, 2));
    num3 = int.parse(cpf.substring(2, 3));
    num4 = int.parse(cpf.substring(3, 4));
    num5 = int.parse(cpf.substring(4, 5));
    num6 = int.parse(cpf.substring(5, 6));
    num7 = int.parse(cpf.substring(6, 7));
    num8 = int.parse(cpf.substring(7, 8));
    num9 = int.parse(cpf.substring(8, 9));
    num10 = int.parse(cpf.substring(9, 10));
    num11 = int.parse(cpf.substring(10, 11));

    if (num1 == num2 &&
        num2 == num3 &&
        num3 == num4 &&
        num4 == num5 &&
        num5 == num6 &&
        num6 == num7 &&
        num7 == num8 &&
        num8 == num9 &&
        num9 == num10 &&
        num10 == num11) {
      return false;
    } else {
      soma1 = num1 * 10 +
          num2 * 9 +
          num3 * 8 +
          num4 * 7 +
          num5 * 6 +
          num6 * 5 +
          num7 * 4 +
          num8 * 3 +
          num9 * 2;
      resto1 = (soma1 * 10) % 11;

      if (resto1 == 10) {
        resto1 = 0;
      }

      soma2 = num1 * 11 +
          num2 * 10 +
          num3 * 9 +
          num4 * 8 +
          num5 * 7 +
          num6 * 6 +
          num7 * 5 +
          num8 * 4 +
          num9 * 3 +
          num10 * 2;
      resto2 = (soma2 * 10) % 11;

      if (resto2 == 10) {
        resto2 = 0;
        
      }

      if (resto1 == num10 && resto2 == num11) {
        return true;
      } else {
        return false;
      }
    }
  }
}
