import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/app/data/providers/login_provider.dart';

class LoginRepository {
  final LoginApiClient apiClient = LoginApiClient();

  LoginRepository();

  Future<Usuario> createUserWithEmailAndPassword(
      String email, String senha) async {
    return await apiClient.createUserWithEmailAndPassword(email, senha);
  }

  Future<void> signInWithEmailAndPassword(String email, String senha) async {
    await apiClient.signInWithEmailAndPassword(email, senha);
  }

  Future<Usuario> loginWithGoogle() async {
    return await apiClient.loginWithGoogle();
  }
}
