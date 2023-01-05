import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class Pulseira {
  late final String id_interno;
  late final String id_fisico;
  late final int id;
  late final int? id_bilhete;
  late final int? id_evento;

  Pulseira.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id_fisico = json['id_fisico'];
    id_bilhete = json['id_bilhete'];
    id_interno = json['id_interno'];
    id_evento = json['id_evento'];
  }
}
