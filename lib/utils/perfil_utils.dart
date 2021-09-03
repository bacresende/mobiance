import 'package:mobiance/app/data/modelo/usuario.dart';

class PerfilUtils {
  static String getPrimeiroNome(String nome) {
    return (nome == null || nome.trim().isEmpty)
        ? 'Usuário'
        : nome.trim().split(' ')[0];
  }

  static String mascaraCpf(String cpf) {
    return (cpf == null || cpf.trim().isEmpty)
        ? ''
        : cpf.replaceAllMapped(
            RegExp(r'([0-9]{3})([0-9]{3})([0-9]{3})([0-9]{2})'),
            (Match m) => "${m[1]}.${m[2]}.${m[3]}-${m[4]}");
  }

  static Usuario cloneToEdit(Usuario usuario) {
    return Usuario.fromJson(usuario.toJsonEditar());
  }

  static void undoEditedClone(Usuario usuario, Usuario clone) {
    usuario.alterarDadosFromJson(clone.toJsonEditar());
  }
}
