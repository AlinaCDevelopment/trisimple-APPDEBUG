import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:nfc_manager/platform_tags.dart' as tags;
import '../models/event_tag.dart';

@immutable
class NfcState {
  EventTag? tag;
  List<Iterable<int>>? bitesRead;
  late String? error;
  String? specs;
  String? session;

  NfcState({
    this.tag,
    this.bitesRead,
    this.error,
    this.specs,
    this.session,
  });

  NfcState.error(this.error);
}

@immutable
class NfcNotifier extends StateNotifier<NfcState> {
  final _ticketIdBlock = 6;
  final _startDateBlock = 7;
  final _lastDateBlock = 8;

  NfcNotifier() : super(NfcState());

  Future<void> inSession(
      Function(NfcTag nfcTag, MifareUltralight mifareTag) onDiscovered) async {
    await NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          final mifare = MifareUltralight.from(tag);
          if (mifare != null) {
            await onDiscovered(tag, mifare);
          } else {
            state = NfcState(error: "A sua tag não é suportada!");
          }
        } on PlatformException catch (platformException) {
          print(platformException.message);
          if (platformException.message == 'Tag was lost.') {
            state = NfcState(
                error:
                    "A tag foi perdida. \nMantenha a tag próxima até obter resultados.");
          } else {
            state = NfcState(error: "Ocorreu um erro de plataforma.");
          }
        } catch (e) {
          state = NfcState(error: "Ocorreu um erro durante a leitura.");
        }
      },
    );
  }

  //==================================================================================================================
  //MAIN METHODS
  Future<void> readClassicTag() async {
    await NfcManager.instance.startSession(
      onDiscovered: (nfcTag) async {
        try {
          final mifareTag = MifareClassic.from(nfcTag);
          if (mifareTag != null) {
            List<Iterable<int>> bites = List.empty(growable: true);
            // mifareTag.
            //  final authenticated = await mifareTag.authenticateSectorWithKeyB(
            ////      sectorIndex: 0,
            //    key: Uint8List.fromList('ffffffffffff'.codeUnits));
            for (int i = 0; i < 39; i++) {
              try {
                // print('auth: $authenticated');
                //https://stackoverflow.com/questions/49879110/write-and-read-data-to-mifare-classic-1k-nfc-tag
                //TODO IGNORE READING MIFARECLASSIC FOR NOW
                final page = await mifareTag.readBlock(blockIndex: i);
                print('$i: $page');
                // print(page.getRange(page.length - 4, page.length));
                print(String.fromCharCodes(page));
                bites.add(page);
              } catch (e) {
                print('err: $i');
                if (e is PlatformException)
                  print((e as PlatformException).message);
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

            state = NfcState(
                tag: null, specs: jsonSpecs, bitesRead: bitesRead, error: null);
          } else {
            state = NfcState(error: "A sua tag não é suportada!");
          }
        } on PlatformException catch (platformException) {
          print(platformException.message);
          if (platformException.message == 'Tag was lost.') {
            state = NfcState(
                error:
                    "A tag foi perdida. \nMantenha a tag próxima até obter resultados.");
          } else {
            state = NfcState(error: "Ocorreu um erro de plataforma.");
          }
        } catch (e) {
          state = NfcState(error: "Ocorreu um erro durante a leitura.");
        }
      },
    );
  }

  Future<void> readTag({
    required MifareUltralight mifareTag,
    required NfcTag nfcTag,
  }) async {
    List<Iterable<int>> bites = List.empty(growable: true);
    for (int i = 0; i < 10; i++) {
      try {
        final page = await mifareTag.readPages(pageOffset: i * 4);
        print(page.getRange(page.length - 4, page.length));
        print(String.fromCharCodes(page));
        bites.add(page);
      } catch (e) {
        print('err: $i');
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
      final eventId = await _readEventId();
      final startDate = await _readDateTime(mifareTag, _startDateBlock);
      final endDate = await _readDateTime(mifareTag, _lastDateBlock);
      eventTag = EventTag(id, eventId, startDate: startDate, endDate: endDate);
    } catch (e) {
      error = ('This tag is not a valid event tag');
    }

    state = NfcState(
        tag: eventTag, specs: jsonSpecs, bitesRead: bitesRead, error: error);
  }

  Future<void> clearTag(MifareUltralight mifareTag) async {
    for (int i = 2; i <= 9; i++) {
      await _writeBlock(tag: mifareTag, block: i, dataString: '');
    }
  }

  Future<void> setTicketId(MifareUltralight mifareTag, String ticketId) async {
    bool success = false;

    try {
      if (mifareTag != null) {
        await _writeBlock(
            dataString: ticketId, block: _ticketIdBlock, tag: mifareTag);
      } else {
        state = NfcState.error("A sua tag não é suportada!");
      }
    } on PlatformException catch (platformException) {
      if (platformException.message == 'Tag was lost.') {
        state = NfcState.error(
            "A tag foi perdida. \nMantenha a tag próxima até obter resultados.");
      } else {
        state = NfcState.error("Ocorreu um erro de plataforma.");
      }
    } catch (e) {
      state = NfcState.error("Ocorreu um erro durante a ESCRITA.");
    }
  }

  Future<void> setDateTimes(
      MifareUltralight mifare, DateTime startDate, DateTime endDate) async {
    if (mifare != null) {
      print('MILISECONDS:');
      print((startDate.millisecondsSinceEpoch));
      await _writeBlock(
          dataString: startDate.millisecondsSinceEpoch.toString(),
          block: _startDateBlock,
          tag: mifare);

      await _writeBlock(
          dataString: endDate.millisecondsSinceEpoch.toString(),
          block: _lastDateBlock,
          tag: mifare);
    } else {
      state = NfcState.error("A sua tag não é suportada!");
    }
  }

  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  void reset() {
    state = NfcState();
  }

  //==================================================================================================================
  //QUICK METHODS
  Future<void> clearTagInSession() async {
    await inSession((nfcTag, mifareTag) async => await clearTag(mifareTag));
  }

  Future<void> readTagInSession() async {
    await inSession((nfcTag, mifareTag) async =>
        await readTag(mifareTag: mifareTag, nfcTag: nfcTag));
  }

  //==================================================================================================================
  //PRIVATE METHODS

  Future<DateTime> _readDateTime(MifareUltralight mifare, int block) async {
    final dataString = await _readBlock(tag: mifare, block: block);
    //Multiply by 10 because we're losing a 0 when reading
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(dataString) * 10);
    return date;
  }

  Future<String> _readId(NfcTag tag) async {
    return tag.data['mifareultralight']['identifier'].toString();
  }

   Future<String> _readEventId() async {
    return '123';
  }

  Future<String> _readBlock(
      {required MifareUltralight tag, required int block}) async {
    final data = await tag.readPages(pageOffset: block * 4);
    data.toList().removeWhere((element) => element == 16);
    final dataString = String.fromCharCodes(data);
    print('DATA READ IN BLOCK $block: $dataString');
    return dataString;
  }

  Future<String> _readClassicBlock(
      {required tags.MifareClassic tag, required int block}) async {
    final data = await tag.readBlock(blockIndex: 0);
    data.toList().removeWhere((element) => element == 16);
    final dataString = String.fromCharCodes(data);
    print('DATA READ IN BLOCK $block: $dataString');
    return dataString;
  }

  Future<void> _writeBlock(
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
    await _readBlock(block: block, tag: tag);
  }
}

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState?>((ref) {
  return NfcNotifier();
});
