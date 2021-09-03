import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/state_manager.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/utils/perfil_utils.dart';

class ElegantDrawerController extends GetxController {
  Usuario usuario = Usuario();
  Firestore db = Firestore.instance;

  getDadosUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    DocumentSnapshot documentSnapshot =
        await db.collection("usuarios").document(user.uid).get();

    return Usuario.fromJson(documentSnapshot.data);
  }

  String getPrimeiroNome(String nome) {
    return PerfilUtils.getPrimeiroNome(nome);
  }
}
