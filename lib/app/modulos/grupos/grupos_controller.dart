import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:mobiance/app/data/modelo/grupo.dart';
import 'package:mobiance/app/modulos/criar_grupo/criar_grupo_tela.dart';
import 'package:mobiance/app/modulos/entrar_grupo/entrar_grupo_tela.dart';

class GruposController extends GetxController {
  Firestore db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  GruposController() {
    this.getGrupos();
  }
  final _clicadoCriarGrupo = false.obs;
  final _clicadoEntrarGrupo = false.obs;
  RxList _listaGrupos = [].obs;
  List<String> itensMenu = ['Criar um Grupo', 'Entrar em um Grupo'];

  List get listaGrupos => _listaGrupos.value;

  bool get clicadoCriargrupo => _clicadoCriarGrupo.value;

  void setClicadoCriarGrupo(bool value) {
    _clicadoCriarGrupo.value = value;
  }

  bool get clicadoEntrarGrupo => _clicadoEntrarGrupo.value;

  void setClicadoEntrarGrupo(bool value) {
    _clicadoEntrarGrupo.value = value;
  }

  @override
  void onInit() {
    this.getGrupos();
    super.onInit();
  }

  Future<void> getGrupos() async {
    FirebaseUser firebaseUser = await auth.currentUser();
    db
        .collection('usuarios')
        .document(firebaseUser.uid)
        .collection('grupos')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      _listaGrupos.value = querySnapshot.documents
          .map((DocumentSnapshot documentSnapshot) =>
              Grupo.fromDocUsuarioGrupoJson(documentSnapshot.data))
          .toList();
    });

  }

  escolhaMenuItem(String itemEscolhido) {
    print(itemEscolhido);
    switch (itemEscolhido) {
      case 'Criar um Grupo':
        Get.to(CriarGrupo());
        break;
      case 'Entrar em um Grupo':
      Get.to(EntrarGrupo(listaGrupos));
        break;
    }
  }
}
