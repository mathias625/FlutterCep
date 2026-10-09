import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pessoa.dart';

class ArquivoService {
  static const String chavePessoas = 'minhas_pessoas';

  Future<void> salvarPessoas(List<Pessoa> pessoas) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lista = pessoas.map((p) => p.toMap()).toList();
      final dados = jsonEncode(lista);
      await prefs.setString(chavePessoas, dados);
    } catch (e) {
      debugPrint('ERRO AO SALVAR PESSOAS: $e');
    }
  }

  Future<List<Pessoa>> carregarPessoas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dados = prefs.getString(chavePessoas);

      if (dados == null || dados.isEmpty) {
        return [];
      }

      final lista = jsonDecode(dados);

      if (lista is! List) {
        return [];
      }

      return lista.map((item) {
        return Pessoa.fromMap(Map<String, dynamic>.from(item));
      }).toList();
    } catch (e) {
      debugPrint('ERRO AO CARREGAR PESSOAS: $e');
      return [];
    }
  }

  Future<void> limparDados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(chavePessoas);
    } catch (e) {
      debugPrint('ERRO AO LIMPAR DADOS: $e');
    }
  }
}