import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobiance/app/data/modelo/usuario.dart';

class UsuarioAtual{

  static Future<FirebaseUser> getUsuarioAtual() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    
    return firebaseUser;
  }

  static Future<Usuario> getUsuario() async {
    Firestore db = Firestore.instance;

    FirebaseUser firebaseUser = await getUsuarioAtual();
    DocumentSnapshot documentSnapshot =
        await db.collection('usuarios').document(firebaseUser.uid).get();
    Usuario usuario = Usuario.fromJson(documentSnapshot.data);

    return usuario;
  }
}