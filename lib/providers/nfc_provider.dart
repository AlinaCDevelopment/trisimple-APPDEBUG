// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
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
            List<Iterable<int>> bites = List.empty(growable: true);
            for (int i = 0; i < 30; i++) {
              final page = await mifare.readPages(pageOffset: i);
              print(page);
              bites.add(page.getRange(0, 4));
            }
            final bitesRead = bites;

            final specs = tag.data;
            var jsonSpecs = jsonEncode(specs)
                .replaceAll('{', '\n{\n')
                .replaceAll('}', '\n}\n')
                .replaceAll(',"', ',\n          "')
                .replaceAll('}\n,\n          "', '},\n"')
                .replaceAll('}\n,\n          "', '},\n"');

            EventTag? eventTag;
            try {
              final id = await _readId();
              final eventId = await _readEventId();
              final startDate = await _readDateTime(mifare, _startDateOffsets);
              final endDate = await _readDateTime(mifare, _endDateOffsets);
              eventTag =
                  EventTag(id, eventId, startDate: startDate, endDate: endDate);
            } catch (e) {}

            state =
                NfcState(tag: eventTag, specs: jsonSpecs, bitesRead: bitesRead);
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

  Future<List<Iterable<int>>> _readBites(MifareUltralight tag) async {
    List<Iterable<int>> bites = List.empty(growable: true);
    for (int i = 0; i < 43; i++) {
      final page = await tag.readPages(pageOffset: i);
      print(page);
      bites.add(page.getRange(0, 4));
    }
    return bites;
  }

  void setDumbError() {
    state = NfcState(error: "Ocorreu um erro de plataforma.");
  }
}

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState?>((ref) {
  return NfcNotifier();
});
