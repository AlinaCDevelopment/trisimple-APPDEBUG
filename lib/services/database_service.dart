import 'dart:convert';

import 'package:app_4/models/event_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;



class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  final _baseAPI = 'http://dev.trisimple.pt';

  Future<bool> tryLogin(String password) async {
    final result = await http.get(Uri.parse('$_baseAPI/login/$password'));
    print(result.body);
    final isPasswordCorrect = json.decode(result.body)['sucess'] == 1;
    return isPasswordCorrect;
  }
}
