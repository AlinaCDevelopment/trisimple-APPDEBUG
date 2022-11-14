import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier()
      : super(Locale.fromSubtags(
            languageCode: Platform.localeName.split('_').first));

  void setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', languageCode);

    state = Locale.fromSubtags(languageCode: languageCode);
  }

  Future<void> getLocaleFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      state = Locale.fromSubtags(languageCode: languageCode);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
