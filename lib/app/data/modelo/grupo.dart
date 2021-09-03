import 'package:mobiance/app/data/modelo/usuario.dart';

class Grupo {
  String nomeGrupo;
  String salario;
  String codigo = '';
  bool isAdmin;
  String nomeUsuario;
  String emailUsuario;
  String idUsuario;
  int qtdeMembros;

  Grupo({this.isAdmin = false}) {
    print('entrou e o admin é $isAdmin');
  }

  Grupo.fromDocUsuarioGrupoJson(Map<String, dynamic> json) {
    this.nomeGrupo = json['nomeGrupo'];
    this.codigo = json['codigo'];
  }

  Map<String, dynamic> toInfoGrupoMap(Usuario usuario) {
    
    Map<String, dynamic> map = {
      'nomeGrupo': this.nomeGrupo,
      'codigo': this.codigo.trim().toUpperCase(),
      'idUsuarioAdmin': usuario.idUsuario,
      'usuarioAdmin': usuario.nome,
      'qtdeMembros': this.qtdeMembros
    };

    return map;
  }

  Map<String, dynamic> toUsuarioGrupoMap(Usuario usuario) {
    Map<String, dynamic> map = {
      'codigo': this.codigo.trim().toUpperCase(),
      'isAdmin': this.isAdmin,
      'nomeUsuario': usuario.nome,
      'emailUsuario': usuario.email,
      'idUsuario': usuario.idUsuario,
      'salario': this.salario
    };

    return map;
  }

  Grupo.fromUsuarioGrupoJson(Map<String, dynamic> json) {
    this.codigo = json['codigo'];
    this.emailUsuario = json['emailUsuario'];
    this.idUsuario = json['idUsuario'];
    this.isAdmin = json['isAdmin'];
    this.nomeUsuario = json['nomeUsuario'];
    this.salario = json['salario'];
  }

  Map<String, dynamic> toDocumentUsuarioGrupoMap() {
    Map<String, dynamic> map = {
      'codigo': this.codigo.trim().toUpperCase(),
      'nomeGrupo': this.nomeGrupo
    };

    return map;
  }

}
