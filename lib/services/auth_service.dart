import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _usuariosKey = 'usuarios';
  static const String _usuarioLogadoKey = 'usuarioLogado';

  // Salva novo usuário
  Future<bool> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> usuarios = prefs.getStringList(_usuariosKey) ?? [];

    for (var user in usuarios) {
      Map<String, dynamic> data = json.decode(user);
      if (data['email'] == email) {
        return false; // email já cadastrado
      }
    }

    Map<String, dynamic> novoUsuario = {
      'nome': nome,
      'email': email,
      'senha': senha,
      'telefone': telefone,
    };

    usuarios.add(json.encode(novoUsuario));
    await prefs.setStringList(_usuariosKey, usuarios);
    return true;
  }

  // Faz login
  Future<bool> login(String email, String senha) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usuarios = prefs.getStringList(_usuariosKey) ?? [];

    for (var user in usuarios) {
      Map<String, dynamic> data = json.decode(user);
      if (data['email'] == email && data['senha'] == senha) {
        await prefs.setString(_usuarioLogadoKey, email);
        return true;
      }
    }
    return false;
  }

  // Verifica se há login salvo
  Future<String?> usuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usuarioLogadoKey);
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usuarioLogadoKey);
  }

  // 🔑 Redefinir senha
  Future<bool> redefinirSenha(String email, String novaSenha) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usuarios = prefs.getStringList(_usuariosKey) ?? [];

    bool encontrou = false;
    for (int i = 0; i < usuarios.length; i++) {
      Map<String, dynamic> user = json.decode(usuarios[i]);
      if (user['email'] == email) {
        user['senha'] = novaSenha;
        usuarios[i] = json.encode(user);
        encontrou = true;
        break;
      }
    }

    if (encontrou) {
      await prefs.setStringList(_usuariosKey, usuarios);
      return true;
    } else {
      return false;
    }
  }
}
