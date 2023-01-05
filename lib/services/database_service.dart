import 'dart:convert';

import 'package:app_debug/models/evento.dart';
import 'package:app_debug/models/pulseira.dart';

import '../models/configuracaoBilhete.dart';
import '../models/event_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  final _baseAPI = 'http://dev.trisimple.pt';

  Future<bool> tryLogin(String password) async {
    final result = await http.get(Uri.parse('$_baseAPI/login/$password'));
    final isPasswordCorrect = json.decode(result.body)['sucess'] == 1;
    return isPasswordCorrect;
  }

  Future<List<Evento>> getEventos() async {
    List<Evento> eventos = List.empty(growable: true);

    final result = await http.get(Uri.parse('$_baseAPI/eventos'));
    final List<dynamic> resultJson = json.decode(result.body);

    for (var equipJson in resultJson) {
      eventos.add(Evento(id: equipJson['id'], nome: equipJson['nome']));
    }
    return eventos;
  }

  Future<List<ConfiguracaoBilhete>> getConfigs(int idEvento) async {
    List<ConfiguracaoBilhete> eventos = List.empty(growable: true);

    final result =
        await http.get(Uri.parse('$_baseAPI/configuracao-bilhetes/$idEvento'));
    final List<dynamic> resultJson = json.decode(result.body);

    for (var configJson in resultJson) {
      eventos.add(ConfiguracaoBilhete.fromJson(configJson));
    }
    return eventos;
  }

  //Gets the bracelet's data from its physical
  Future<Pulseira?> getBraceletByInternalId(String id) async {
    final result =
        await http.get(Uri.parse('$_baseAPI/pulseira-interno?id_interno=$id'));
    final List<dynamic> resultJson = json.decode(result.body);
    if (resultJson.isEmpty) {
      return null;
    }
    final Map<String, dynamic> jsonData = resultJson.first;
    return Pulseira.fromJson(jsonData);
  }

  ///Generates a ticket with the sent data
  Future<bool> genDebugTicket(
    int idEvento,
    int idConfiguracao,
    int idPulseira,
    String nome,
  ) async {
    final result =
        await http.put(Uri.parse('$_baseAPI/gerar-bilhete-debug'), body: {
      "id_configuracao": idConfiguracao,
      "id_evento": idEvento,
      "id_pulseira": idPulseira,
      "nome": nome
    });
    return json.decode(result.body)['sucess'] == 1;
    ;
  }
}
