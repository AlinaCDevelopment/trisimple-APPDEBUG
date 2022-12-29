import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:nfc_manager/platform_tags.dart' as tags;
import '../constants/nfc_blocks.dart';
import '../models/event_tag.dart';
import '../services/l10n/app_localizations.dart';

@immutable
class NfcState {
  final EventTag? tag;
  final List<Iterable<int>>? bytesRead;
  final String? error;
  final String? specs;
  final String? handle;

  const NfcState({
    this.tag,
    this.bytesRead,
    this.error,
    this.specs,
    this.handle,
  });
}

@immutable
class NfcNotifier extends StateNotifier<NfcState> {
  NfcNotifier() : super(const NfcState());

  Future<void> inSession(BuildContext context,
      {required Future<void> Function(NfcTag nfcTag, MifareClassic mifareTag)
          onDiscovered}) async {
    await NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          final mifare = MifareClassic.from(tag);
          if (mifare != null) {
            //try {
            await onDiscovered(tag, mifare);
            /*  } on SocketException {
              DatabaseService.instance.setDataSource(isConnected: false);
              await onDiscovered(tag, mifare);
            } */
          } else {
            state =
                NfcState(error: (AppLocalizations.of(context).unsupportedTag));
          }
        } on PlatformException catch (platformException) {
          if (platformException.message == 'Tag was lost.') {
            state = NfcState(error: (AppLocalizations.of(context).tagLost));
          } else {
            state =
                NfcState(error: (AppLocalizations.of(context).platformError));
          }
        } catch (e) {
          state = NfcState(error: (AppLocalizations.of(context).processError));
          throw (e);
        }
      },
    );
  }

  //==================================================================================================================
  //MAIN METHODS

  ///Reads data from [mifareTag] and [nfcTag] and sets the provider's state from it
  Future<void> readTag({
    required MifareClassic mifareTag,
    required NfcTag nfcTag,
  }) async {
    List<Iterable<int>> bites = List.empty(growable: true);
    for (int i = 0; i < 16; i++) {
      try {
        final page = await _readSectorData(tag: mifareTag, sector: i);
        // print(page.getRange(page.length - 4, page.length));
        print('$i: ${String.fromCharCodes(page)}');
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

    EventTag? eventTag;
    String? error;
    try {
      final id = await _readId(nfcTag);
      final ticketAndEventBytes = (await _readBlockAsBytes(mifareTag,
          storageSlot: ticketIdEventIdStorage));
      final ticketIdBytes = ticketAndEventBytes.getRange(0, 8);
      final eventIdBytes = ticketAndEventBytes.getRange(8, 15);
      final ticketId = String.fromCharCodes(ticketIdBytes);
      final eventId = String.fromCharCodes(eventIdBytes);
      final startDate = await _readDateTime(mifareTag, starttDateStorage);
      final endDate = await _readDateTime(mifareTag, endDateStorage);
      final title =
          await _readBlockAsString(mifareTag, storageSlot: titleStorage);
      eventTag = EventTag(id, eventId, ticketId,
          startDate: startDate, endDate: endDate);
    } catch (e) {
      //TODO Fix datetimes
      print('err getting event tag: $e');
      if (e is FormatException) {
        print('source: ${e.message.toString()}');
      }
    }

    state = NfcState(
        tag: eventTag,
        handle: nfcTag.handle,
        specs: jsonSpecs,
        bytesRead: bitesRead,
        error: error);
  }

  ///Cleats any data possibly written by the trisimple apps inside [mifareTag]
  ///This sets most of its bytes to 0
  Future<void> clearTag(MifareClassic mifareTag) async {
    throw (UnimplementedError());
  }

  /// Stores the [ticketId] in the [mifareTag]
  Future<void> setTicketAndEventsIds(
      MifareClassic mifareTag, String ticketId, String eventId) async {
//the ticlet amd event ids are stored in a single block
    final ticketPart = ticketId.codeUnits.toList();
    ticketPart.addAll(List.filled(8 - ticketId.codeUnits.length, 0));
    final eventPart = ticketId.codeUnits.toList();
    eventPart.addAll(List.filled(8 - ticketId.codeUnits.length, 0));

    await _writeBytesBlock(
        tag: mifareTag,
        block: ticketIdEventIdStorage.blocksInSector.single,
        sector: ticketIdEventIdStorage.sector,
        bytes: [...ticketPart, ...eventPart]);
  }

  Future<void> setDateTimes(
      MifareClassic mifare, DateTime startDate, DateTime endDate) async {
    await _writeString(
        dataString: startDate.millisecondsSinceEpoch.toString(),
        storageSlot: starttDateStorage,
        tag: mifare);

    await _writeString(
        dataString: endDate.millisecondsSinceEpoch.toString(),
        storageSlot: endDateStorage,
        tag: mifare);
  }

  Future<void> setTitle(MifareClassic mifare, String title) async {
    await _writeString(
        dataString: title, storageSlot: titleStorage, tag: mifare);
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

  //==================================================================================================================
  //QUICK METHODS
  Future<void> clearTagInSession(BuildContext context) async {
    throw (UnimplementedError());
    await inSession(context,
        onDiscovered: (nfcTag, mifareTag) async => await clearTag(mifareTag));
  }

  Future<void> readTagInSession(BuildContext context) async {
    // throw (UnimplementedError());

    await inSession(context, onDiscovered: (nfcTag, mifareTag) async {
      await readTag(mifareTag: mifareTag, nfcTag: nfcTag);
    });
  }

  //==================================================================================================================
  //PRIVATE METHODS

  Future<DateTime> _readDateTime(
      MifareClassic mifare, NfcStorageSlot storageSlot) async {
    final dataString =
        (await _readBlockAsString(mifare, storageSlot: storageSlot));
    print(int.parse(dataString));
    //Multiply by 10 because we're losing a 0 when reading
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(dataString) * 10);
    return date;
  }

  Future<String> _readId(NfcTag tag) async {
    return 'TODO GET FROM 0-0 BLOCK';
    return tag.data['MifareClassic']['identifier'].toString();
  }

  Future<String> _readBlockAsString(MifareClassic tag,
      {required NfcStorageSlot storageSlot}) async {
    var stringsRead = List<String>.empty(growable: true);
    final success = await tag.authenticateSectorWithKeyA(
        sectorIndex: storageSlot.sector, key: keyB);
    for (var block in storageSlot.blocksInSector) {
      final blockIndex = block + storageSlot.sector * 4;
      final data = await tag.readBlock(blockIndex: blockIndex);
      //   data.toList().removeWhere((element) => element == 16);
      final filteredData = List<int>.from(data, growable: true);
      filteredData.removeWhere((element) => element == 0);
      stringsRead.add(String.fromCharCodes(filteredData));
    }
    final dataString = stringsRead.join("");
    print(
        'DATA READ IN BLOCKS ${storageSlot.blocksInSector} IN SECTOR ${storageSlot.sector}: $dataString');
    return dataString;
  }

  Future<List<int>> _readBlockAsBytes(MifareClassic tag,
      {required NfcStorageSlot storageSlot}) async {
    var bytesRead = List<int>.empty(growable: true);
    for (var block in storageSlot.blocksInSector) {
      final success = await tag.authenticateSectorWithKeyA(
          sectorIndex: storageSlot.sector, key: keyB);

      final blockIndex = block + storageSlot.sector * 4;
      final data = (await tag.readBlock(blockIndex: blockIndex)).toList();
      data.removeWhere((element) => element == 16);
      bytesRead.addAll(data);
    }
    return bytesRead;
  }
}

//TODO LATER CONFIRM ULTRALIGHT NORMAL READING
Future<Uint8List> _readSectorData(
    {required MifareClassic tag, required int sector}) async {
  //   mifares.FlutterNfcMifare mifare;
  //   FlutterNfcMifare.readMF1();
  final List<int> bytes = List.empty(growable: true);
  //Reading the 16 bytes of each 4 blocks inside a sector

  for (var i = sector * 4; i < sector * 4 + 4; i++) {
    try {
      Uint8List keyB = Uint8List.fromList([255, 255, 255, 255, 255, 255]);
      //  keyB = Uint8List.fromList('albnet'.codeUnits);
      Uint8List keyA = Uint8List.fromList([0, 0, 0, 0, 0, 0]);
      final success =
          await tag.authenticateSectorWithKeyA(sectorIndex: sector, key: keyB);
      if (!success) print('sucess auth : $success');
      //if (success) {
      final blockData = await tag.readBlock(blockIndex: i);
      bytes.addAll(blockData);
      //  }
    } catch (e) {
      print(e);
    }
  }
  return Uint8List.fromList(bytes);
}

///Writes the string to the tag
///
Future<void> _writeString(
    {required MifareClassic tag,
    required NfcStorageSlot storageSlot,
    required String dataString}) async {
  print('string: $dataString');
  for (var i = 0; i < storageSlot.blocksInSector.length; i++) {
    final subString = dataString.characters.length > 16 * (i + 1)
        ? dataString.substring(16 * i, 16 * (i + 1))
        : dataString;
    dataString = dataString.replaceFirst(subString, '');

    print('Sub String: $subString');
    List<int> data = List<int>.generate(16, (index) {
      if (subString.codeUnits.length > index) {
        return subString.codeUnits[index];
      }
      return 0;
    });
    print('Data: $data');
    await _writeBytesBlock(
        tag: tag,
        block: storageSlot.blocksInSector[i],
        sector: storageSlot.sector,
        bytes: data);
    print('done : ${storageSlot.sector}');
  }
}

Future<void> _writeBytesBlock(
    {required MifareClassic tag,
    required int block,
    required int sector,
    required List<int> bytes}) async {
  final data = Uint8List.fromList(bytes);

  await tag.authenticateSectorWithKeyA(sectorIndex: sector, key: keyB);
  final blockIndex = block + sector * 4;
  await tag.writeBlock(blockIndex: blockIndex, data: data);
}

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState?>((ref) {
  return NfcNotifier();
});
