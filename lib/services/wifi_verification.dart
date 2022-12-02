import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/ui/dialog_messages.dart';
import 'l10n/app_localizations.dart';

Future<bool> checkWifi() async {
  try {
    final searchResult = await InternetAddress.lookup('example.com');
    return searchResult.isNotEmpty && searchResult[0].rawAddress.isNotEmpty;
  } on SocketException {
    return false;
  }
}

Future<bool> checkWifiWithValidation(BuildContext context) async {
  final isConnected = await checkWifi();
  print(isConnected);
  if (!isConnected)
    await showMessageDialog(
      context,
      DialogMessage(
        content: AppLocalizations.of(context).connectionError,
        title: AppLocalizations.of(context).tryAgain,
      ),
    );
  return isConnected;
}
