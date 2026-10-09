import 'dart:convert';

class Pessoa {
  final String id;
  final String nome;
  final String cep;
  final String rua;
  final String numero;
  final String complemento;
  final String bairro;
  final String cidade;
  final String estado;

  Pessoa({
    required this.id,
    required this.nome,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id']?.toString() ?? '',
      nome: map['nome']?.toString() ?? '',
      cep: map['cep']?.toString() ?? '',
      rua: map['rua']?.toString() ?? '',
      numero: map['numero']?.toString() ?? '',
      complemento: map['complemento']?.toString() ?? '',
      bairro: map['bairro']?.toString() ?? '',
      cidade: map['cidade']?.toString() ?? '',
      estado: map['estado']?.toString() ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Pessoa.fromJson(String source) => Pessoa.fromMap(jsonDecode(source));
}