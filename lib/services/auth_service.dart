import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Função para registrar um usuário com email e senha
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Retorna o usuário autenticado
    } catch (e) {
      print('Erro ao registrar: $e');
      return null;
    }
  }

  // Função para login com email e senha
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Retorna o usuário autenticado
    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }
  }

  // Função para logout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Função para obter o usuário autenticado atual
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }
}