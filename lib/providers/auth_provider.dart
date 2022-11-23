import 'dart:convert';


import '../services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';



@immutable
class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  Future<bool> authenticateFromPreviousLogs() async {
      final prefs = await SharedPreferences.getInstance();
      final isLogged = prefs.getBool('authentication');
      if(isLogged!=null) {
        return isLogged;
      }
      return false;
  }

  Future<bool> authenticate(String password) async {

    final isPasswordCorrect = await DatabaseService.instance.tryLogin(password);
    await _setDeviceAuth(isPasswordCorrect);
    return isPasswordCorrect;
  }

  Future<void> resetAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authentication');
  }

  Future<bool> _setDeviceAuth(bool isAuth) async {
    final prefs = await SharedPreferences.getInstance();
    final authSet =
        await prefs.setBool('authentication', isAuth);
        return authSet;
}}

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});