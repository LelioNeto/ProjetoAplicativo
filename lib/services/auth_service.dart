import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===============================
  // CADASTRAR NOVO USUÁRIO
  // ===============================

  Future<bool> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
  }) async {
    try {
      // Cria usuário no Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Cria documento no Firestore (coleção "usuarios")
      await _firestore.collection("usuarios").doc(cred.user!.uid).set({
        "nome": nome,
        "email": email,
        "telefone": telefone,
        "id": cred.user!.uid,
        "createdAt": DateTime.now(),
      });

      return true;
    } catch (e) {
      print("Erro ao cadastrar usuário: $e");
      return false;
    }
  }

  // ===============================
  // LOGIN
  // ===============================

  Future<bool> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print("Erro no login: ${e.code} - ${e.message}");
      return false;
    }
  }

  // ===============================
  // RETORNAR EMAIL DO USUÁRIO LOGADO
  // ===============================

  Future<String?> usuarioLogado() async {
    return _auth.currentUser?.email;
  }

  // ===============================
  // RETORNAR NOME DO USUÁRIO LOGADO
  // ===============================

  Future<String?> nomeUsuarioLogado() async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) return null;

    final doc = await _firestore.collection("usuarios").doc(uid).get();

    return doc.data()?["nome"];
  }

  // ===============================
  // LOGOUT
  // ===============================

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ===============================
  // REDEFINIR SENHA
  // ===============================

  Future<bool> redefinirSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("Erro ao redefinir senha: $e");
      return false;
    }
  }
}
