import 'package:mobiance/app/data/modelo/grupo.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/utils/perfil_utils.dart';
import 'package:share/share.dart';

class CompartilhaCodigo {
  static Future<void> share({Usuario usuario, Grupo grupo}) async {
    String mensagem = '';
    String nome = PerfilUtils.getPrimeiroNome(usuario.nome);
    String nomeGrupo = grupo.nomeGrupo;
    String codigo = grupo.codigo;

    mensagem =
        '$nome está no Mobiance e enviou um código para você se juntar ao grupo *$nomeGrupo* . \nPara entrar: \nAcesse o menu "grupos" \nClique em "Entrar em um grupo" \nE digite o código: *$codigo*';
    print(mensagem);
    await Share.share(mensagem,
        subject: 'Compartilhar código do grupo $nomeGrupo');
  }
}
