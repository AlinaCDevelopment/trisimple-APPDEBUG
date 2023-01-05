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
  if (!isConnected) {
    showWifiErrorMessage(context);
  }
  return isConnected;
}

Future<void> showWifiErrorMessage(BuildContext context) async {
  await showMessageDialog(
    context,
    MessageDialog(
      title: AppLocalizations.of(context).connectionError,
      content: AppLocalizations.of(context).tryAgain,
    ),
  );
}
