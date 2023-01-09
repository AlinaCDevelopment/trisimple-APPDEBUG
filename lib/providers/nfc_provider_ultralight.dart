import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:nfc_manager/platform_tags.dart' as tags;
import '../constants/nfc_blocks_ultralight.dart';
import '../models/event_tag.dart';
import '../services/l10n/app_localizations.dart';
import 'nfc_provider_base.dart';

@immutable
class NfcNotifierUltralight extends NfcNotifierBase {
  //==================================================================================================================
  //MAIN METHODS

  ///Reads data from [mifareTag] and [nfcTag] and sets the provider's state from it
  @override
  Future<NfcState> readTag({
    required NfcTag nfcTag,
  }) async {
    final mifareTag = MifareUltralight.from(nfcTag)!;
    List<Iterable<int>> bites = List.empty(growable: true);
    for (int i = 0; i < 10; i++) {
      try {
        final page = await mifareTag.readPages(pageOffset: i * 4);
        print(page.getRange(page.length - 4, page.length));
        print(String.fromCharCodes(page));
        bites.add(page);
      } catch (e) {
        print('err: $i');
        break;
      }
    }
    final bitesRead = bites;

    final specs = nfcTag.data;
    var jsonSpecs = jsonEncode(specs)
        .replaceAll('{', '\n{\n')
        .replaceAll('}', '\n}\n')
        .replaceAll(',"', ',\n          "')
        .replaceAll('}\n,\n          "', '},\n"')
        .replaceAll('}\n,\n          "', '},\n"');

    Bilhete? eventTag;
    String? error;
    final internalId = mifareTag.identifier.toString();
    try {
      final ticketId = await _readBlock(tag: mifareTag, block: ticketIdBlock);
      final eventId = await _readBlock(tag: mifareTag, block: eventIdBlock);

      final balance = await _readBalance(mifareTag);

      final startDate = await _readDateTime(mifareTag, startDateBlock);
      final endDate = await _readDateTime(mifareTag, endDateBlock);
      final title = await _readTitle(mifareTag);
      eventTag = Bilhete(internalId, int.parse(eventId), (int.parse(ticketId)),
          title: title,
          balance: balance,
          startDate: startDate,
          endDate: endDate);
    } catch (e) {
      print('err getting event tag: $e');
      if (e is FormatException) {
        print('source: ${e.message.toString()}');
      }
    }

    state = NfcState(
        bilhete: eventTag,
        handle: nfcTag.handle,
        specs: jsonSpecs,
        internalId: internalId,
        bytesRead: bitesRead,
        error: error);
    return state;
  }

  ///Cleats any data possibly written by the trisimple apps inside [mifareTag]
  ///This sets most of its bytes to 0
  @override
  Future<void> clearTag(NfcTag nfcTag) async {
    throw (UnimplementedError());
  }

  ///Reduces from the [balance] of the [Bilhete] stored in the [mifareTag] the [amount] specified
  ///
  ///Returns false if the [balance] insde the [mifareTag] is smaller than [amount]
  @override
  Future<bool> reduceBalance(NfcTag nfcTag, double amount) async {
    final mifareTag = MifareUltralight.from(nfcTag)!;
    final currentBalance = await _readBalance(mifareTag);
    if (amount > currentBalance) {
      return false;
    }
    await setBalance(nfcTag, balance: currentBalance - amount);
    return true;
  }
  //TODO USE THESE IN THE NEW SCREEN

  ///Adds to the [balance] of the [Bilhete] stored in the [mifareTag] the [amount] specified
  @override
  Future<void> increaseBalance(NfcTag nfcTag, double amount) async {
    final mifareTag = MifareUltralight.from(nfcTag)!;
    final currentBalance = await _readBalance(mifareTag);
    final newBalance = (currentBalance + amount).toString();
    await _writeString(
        tag: mifareTag, block: balanceBlock, dataString: newBalance);
  }

  @override
  Future<void> setDateTimes(
      NfcTag nfcTag, DateTime? startDate, DateTime? endDate) async {
    final mifare = MifareUltralight.from(nfcTag)!;
    await _writeString(
        dataString: startDate == null
            ? 'null'
            : startDate.millisecondsSinceEpoch.toString(),
        block: startDateBlock,
        tag: mifare);

    await _writeString(
        dataString: endDate == null
            ? 'null'
            : endDate.millisecondsSinceEpoch.toString(),
        block: endDateBlock,
        tag: mifare);
  }

  /// Stores the [ticketId] in the [mifareTag]
  @override
  Future<void> setTicketAndEventsIds(
      NfcTag nfcTag, String ticketId, String eventId) async {
    final tag = MifareUltralight.from(nfcTag)!;
    await _writeString(
        tag: tag, block: ticketIdBlock, dataString: ticketId.toString());
    await _writeString(
        tag: tag, block: eventIdBlock, dataString: eventId.toString());
  }

  @override
  Future<void> setTitle(NfcTag nfcTag, String title) async {
    final mifare = MifareUltralight.from(nfcTag)!;
    final part1 = title.substring(1, 20);
    final part2 = title.characters.length > 20 ? title.substring(21) : '';
    await _writeString(dataString: part1, block: titleBlock1, tag: mifare);
    await _writeString(dataString: part2, block: titleBlock2, tag: mifare);
  }

/*   Future<void> write1kTest(MifareClassic tag, String message) async {
    final testData = Uint8List.fromList(
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16].toList());
    final clearData = Uint8List.fromList(
        [10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].toList());

    final success =
        await tag.authenticateSectorWithKeyA(sectorIndex: 0, key: keyB);
    if (success) print('sucess auth : $success');
    final blockData = await tag.writeBlock(blockIndex: 1, data: clearData);
  } */

  ///Whether the nfc service is activated or available in the device
  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  ///Resets the state of the notifier
  ///This removes any errors and read data
  void reset() {
    state = const NfcState();
  }

  Future<void> testSetAuth(MifareClassic mifare) async {}

  //==================================================================================================================
  //PRIVATE METHODS

  Future<DateTime> _readDateTime(MifareUltralight mifare, int block) async {
    final dataString = await _readBlock(tag: mifare, block: block);
    //Multiply by 10 because we're losing a 0 when reading
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(dataString) * 10);
    return date;
  }

  Future<String> _readTitle(MifareUltralight mifare) async {
    final title1 = await _readBlock(tag: mifare, block: titleBlock1);
    final title2 = await _readBlock(tag: mifare, block: titleBlock2);
    return title1 + title2;
  }

  Future<double> _readBalance(
    MifareUltralight mifareTag,
  ) async {
    final balanceString = await _readBlock(tag: mifareTag, block: balanceBlock);

    return double.parse(balanceString);
  }

  Future<String> _readBlock(
      {required MifareUltralight tag, required int block}) async {
    try {
      final data = await tag.readPages(pageOffset: block * 4);
      final convertedData = data.toList();
      convertedData.removeWhere((element) {
        return element == 0;
      });
      //TODO try authentication with transceive
      /**
       * byte[] result1 = mifare.transceive(new byte[] {
            (byte)0xA1,  /* CMD = AUTHENTICATE */
            (byte)0x00
});
       */
      // tag.transceive(data: data)
      final dataString =
          String.fromCharCodes(Uint8List.fromList(convertedData));
      print('DATA READ IN BLOCK $block: $dataString');
      return dataString.trim();
    } catch (e) {
      print(e);
      if (e is PlatformException) {
        print(e.details);
      }
      throw (e);
    }
  }

  @override
  Future<void> setBalance(NfcTag nfcTag, {double balance = 0}) async {
    await _writeString(
        dataString: balance.toString(),
        block: balanceBlock,
        tag: MifareUltralight.from(nfcTag)!);
  }

  ///Writes the string to the tag
  ///
  Future<void> _writeString(
      {required MifareUltralight tag,
      required int block,
      required String dataString}) async {
    List<int> data = List<int>.generate(20, (index) {
      if (dataString.codeUnits.length > index) {
        return dataString.codeUnits[index];
      }
      return 0;
    });
    await tag.writePage(
        pageOffset: block * 4,
        data: Uint8List.fromList(data.getRange(0, 4).toList()));
    await tag.writePage(
        pageOffset: block * 4 + 1,
        data: Uint8List.fromList(data.getRange(4, 8).toList()));
    await tag.writePage(
        pageOffset: block * 4 + 2,
        data: Uint8List.fromList(data.getRange(8, 12).toList()));
    await tag.writePage(
        pageOffset: block * 4 + 3,
        data: Uint8List.fromList(data.getRange(12, 16).toList()));
    await tag.writePage(
        pageOffset: block * 4 + 3,
        data: Uint8List.fromList(data.getRange(16, 20).toList()));

    print("DATA SAVED IN BLOCK $block | DATA SAVED : $dataString");
  }
}
