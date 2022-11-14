import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../models/event_tag.dart';

@immutable
class NfcState {
  EventTag? tag;
  List<String>? bitesRead;
  late String? error;
  Map<String, dynamic>? specs;

  NfcState({this.tag, this.error, this.bitesRead, this.specs});
  //TODO Add this constructor to appdebug
  NfcState.error(this.error);
}

@immutable
class NfcNotifier extends StateNotifier<NfcState> {
  final _startDateOffsets = [16, 17, 18];
  final _endDateOffsets = [20, 21, 22];
  final _idOffsets = [20, 21, 22];

  NfcNotifier() : super(NfcState());

  Future<void> readTag() async {
    await NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          final mifare = MifareUltralight.from(tag);
          if (mifare != null) {
            final startDate = await _readDateTime(mifare, _startDateOffsets);
            final endDate = await _readDateTime(mifare, _endDateOffsets);
            final id = await _readId();
            final eventId = await _readEventId();
            final bitesRead = await _readBites(mifare);

            final specs = tag.data;

            state = NfcState(
                tag: EventTag(id, eventId,
                    startDate: startDate, endDate: endDate),
                specs: specs,
                bitesRead: bitesRead);
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

  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  void reset() {
    state = NfcState();
  }

  //==================================================================================================================
  //PRIVATE METHODS

  Future<DateTime> _readDateTime(
      MifareUltralight mifare, List<int> offsets) async {
    final day = await mifare.readPages(pageOffset: offsets[0]);
    final month = await mifare.readPages(pageOffset: offsets[1]);
    final year = await mifare.readPages(pageOffset: offsets[2]);

    final date = DateTime(
      int.parse(String.fromCharCodes(year).substring(0, 4)),
      int.parse(String.fromCharCodes(month).substring(0, 4)),
      int.parse(String.fromCharCodes(day).substring(0, 4)),
    );
    return date;
  }

  Future<int> _readId() async {
    return 0;
  }

  Future<int> _readEventId() async {
    return 0;
  }

  Future<List<String>> _readBites(MifareUltralight tag) async {
    List<String> bites = List.empty(growable: true);
    //TODO Find max
    for (int i = 0; i < 32; i++) {
      final page = await tag.readPages(pageOffset: i);
      final pageText = String.fromCharCodes(page);
      bites.add("${page.toString()}-$pageText");
    }
    return bites;
  }
}

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState?>((ref) {
  return NfcNotifier();
});
