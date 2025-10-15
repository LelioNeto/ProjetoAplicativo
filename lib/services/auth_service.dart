import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _usuariosKey = 'usuarios';
  static const String _usuarioLogadoKey = 'usuarioLogado';
  static const String _usuarioLogadoNomeKey = 'usuarioLogadoNome';

  // Salva novo usuário
  Future<bool> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> usuarios = prefs.getStringList(_usuariosKey) ?? [];

    // Verifica se o e-mail já existe
    for (var user in usuarios) {
      Map<String, dynamic> data = json.decode(user);
      if (data['email'] == email) {
        return false; // e-mail já cadastrado
      }
    }

    // Cria o novo usuário
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
        // Salva email e nome do usuário logado
        await prefs.setString(_usuarioLogadoKey, email);
        await prefs.setString(_usuarioLogadoNomeKey, data['nome']);
        return true;
      }
    }
    return false;
  }

  // Retorna o e-mail do usuário logado
  Future<String?> usuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usuarioLogadoKey);
  }

  // Retorna o nome do usuário logado
  Future<String?> nomeUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usuarioLogadoNomeKey);
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usuarioLogadoKey);
    await prefs.remove(_usuarioLogadoNomeKey);
  }

  // Redefinir senha
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
