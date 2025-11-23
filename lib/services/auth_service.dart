import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  // CADASTRO DE NOVO USUÁRIO
  // ============================================================
  Future<String?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
  }) async {
    try {
      // Regras básicas de validação
      if (senha.length < 6) {
        return "A senha deve ter pelo menos 6 caracteres.";
      }

      // Criar usuário no Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      final uid = cred.user!.uid;

      // Salvar no Firestore
      await _firestore.collection("usuarios").doc(uid).set({
        "id": uid,
        "nome": nome.trim(),
        "email": email.trim(),
        "telefone": telefone.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      return null; // Sucesso (null = sem erro)
    } on FirebaseAuthException catch (e) {
      return _traduzErroAuth(e);
    } catch (e) {
      return "Erro inesperado: $e";
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================
  Future<String?> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _traduzErroAuth(e);
    } catch (e) {
      return "Erro inesperado: $e";
    }
  }

  // ============================================================
  // VERIFICAR USUÁRIO LOGADO
  // ============================================================
  Future<String?> usuarioLogado() async {
    return _auth.currentUser?.uid;
  }

  // ============================================================
  // PEGAR NOME DO USUÁRIO LOGADO
  // ============================================================
  Future<String?> nomeUsuarioLogado() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    try {
      final doc = await _firestore.collection("usuarios").doc(uid).get();
      return doc.data()?["nome"];
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ============================================================
  // REDEFINIÇÃO DE SENHA
  // ============================================================
  Future<String?> redefinirSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _traduzErroAuth(e);
    } catch (e) {
      return "Erro inesperado: $e";
    }
  }

  // ============================================================
  // TRADUTOR DE ERROS DO FIREBASE (em português)
  // ============================================================
  String _traduzErroAuth(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        return "O e-mail informado é inválido.";
      case "user-disabled":
        return "Este usuário foi desativado.";
      case "user-not-found":
        return "Usuário não encontrado.";
      case "wrong-password":
        return "Senha incorreta.";
      case "email-already-in-use":
        return "Este e-mail já está cadastrado.";
      case "weak-password":
        return "A senha é muito fraca.";
      case "operation-not-allowed":
        return "Operação não permitida.";
      default:
        return "Erro inesperado: ${e.message}";
    }
  }
}
