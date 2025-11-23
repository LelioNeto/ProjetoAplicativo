import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _uid() {
    final user = _auth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');
    return user.uid;
  }

  // =========================
  // PRODUTOS (coleção: usuarios/{uid}/produtos)
  // =========================

  Future<void> addProduto({
    required String nome,
    required int quantidade,
    required String categoria,
    required bool comprado,
  }) async {
    final uid = _uid();
    final docRef = _db.collection('usuarios').doc(uid).collection('produtos').doc();
    final now = FieldValue.serverTimestamp();

    await docRef.set({
      'nome': nome,
      'quantidade': quantidade,
      'categoria': categoria,
      'comprado': comprado,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<void> updateProduto({
    required String id,
    String? nome,
    int? quantidade,
    String? categoria,
    bool? comprado,
  }) async {
    final uid = _uid();
    final data = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};
    if (nome != null) data['nome'] = nome;
    if (quantidade != null) data['quantidade'] = quantidade;
    if (categoria != null) data['categoria'] = categoria;
    if (comprado != null) data['comprado'] = comprado;

    await _db.collection('usuarios').doc(uid).collection('produtos').doc(id).update(data);
  }

  Future<void> deleteProduto(String id) async {
    final uid = _uid();
    await _db.collection('usuarios').doc(uid).collection('produtos').doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamProdutos({String orderBy = 'createdAt', bool descending = true}) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      // retornamos stream vazio para evitar exceção na UI até o login.
      return const Stream.empty() as Stream<QuerySnapshot<Map<String, dynamic>>>;
    }
    return _db
        .collection('usuarios')
        .doc(uid)
        .collection('produtos')
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }

  // =========================
  // RECEITAS (coleção: usuarios/{uid}/receitas)
  // =========================

  Future<void> addReceita({
    required String nome,
    required Map<String, dynamic> ingredientes,
    required String modoPreparo,
    bool favorito = false,
  }) async {
    final uid = _uid();
    final docRef = _db.collection('usuarios').doc(uid).collection('receitas').doc();
    final now = FieldValue.serverTimestamp();

    await docRef.set({
      'nome': nome,
      'ingredientes': ingredientes,
      'modoPreparo': modoPreparo,
      'favorito': favorito,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<void> updateReceita({
    required String id,
    String? nome,
    Map<String, dynamic>? ingredientes,
    String? modoPreparo,
    bool? favorito,
  }) async {
    final uid = _uid();
    final data = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};
    if (nome != null) data['nome'] = nome;
    if (ingredientes != null) data['ingredientes'] = ingredientes;
    if (modoPreparo != null) data['modoPreparo'] = modoPreparo;
    if (favorito != null) data['favorito'] = favorito;

    await _db.collection('usuarios').doc(uid).collection('receitas').doc(id).update(data);
  }

  Future<void> deleteReceita(String id) async {
    final uid = _uid();
    await _db.collection('usuarios').doc(uid).collection('receitas').doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamReceitas({String orderBy = 'createdAt', bool descending = true}) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty() as Stream<QuerySnapshot<Map<String, dynamic>>>;
    return _db
        .collection('usuarios')
        .doc(uid)
        .collection('receitas')
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }
}
