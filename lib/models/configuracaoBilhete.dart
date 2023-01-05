import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class ConfiguracaoBilhete {
  late final String titulo;
  late final int id;
  ConfiguracaoBilhete({required this.id, required this.titulo});

  ConfiguracaoBilhete.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    id = json['id'];
  }
}
