import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MultiLang {
  static late AppLocalizations _texts;
  static late List<LocalizationsDelegate<dynamic>> _localizationsDelegates;
  static late List<Locale> _supportedLocales;

  static AppLocalizations get texts => _texts;
  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      _localizationsDelegates;
  static List<Locale> get supportedLocales => _supportedLocales;

  static Future<void> init(Locale locale) async {
    _texts = await AppLocalizations.delegate.load(locale);
    _localizationsDelegates = AppLocalizations.localizationsDelegates;
    _supportedLocales = AppLocalizations.supportedLocales;
  }
}
