import 'dart:io';

Future<bool> checkWifi() async {
  try {
    final searchResult = await InternetAddress.lookup('example.com');
    return searchResult.isNotEmpty && searchResult[0].rawAddress.isNotEmpty;
  } on SocketException {
    return false;
  }
}
