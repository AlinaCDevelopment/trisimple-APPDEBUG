import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class Evento {
  late final String nome;
  late final int id;
  Evento({required this.id, required this.nome});

  Evento.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    id = json['id'];
    nome = json['nome'];
  }
  String toJson() {
    final map = {
      'id': id,
      'nome': nome,
    };
    return jsonEncode(map);
  }
}
