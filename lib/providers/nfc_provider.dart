import 'dart:convert';
import 'package:app_debug/providers/nfc_provider_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:nfc_manager/platform_tags.dart' as tags;
import '../constants/nfc_blocks_classic.dart';
import '../models/event_tag.dart';
import '../services/l10n/app_localizations.dart';
import 'nfc_provider_classic.dart';
import 'nfc_provider_ultralight.dart';

@immutable
class NfcNotifier extends NfcNotifierBase {
  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  Future<void> inSession(BuildContext context,
      {required Future<void> Function(NfcTag nfcTag) onDiscovered}) async {
    await NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          var isValidTagType = MifareUltralight.from(tag) != null;
          if (!isValidTagType) {
            isValidTagType = MifareClassic.from(tag) != null;
          }
          if (isValidTagType) {
            await onDiscovered(tag);
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

  @override
  Future<void> clearTag(NfcTag nfcTag) {
    // TODO: implement clearTag
    throw UnimplementedError();
  }

  @override
  Future<void> increaseBalance(NfcTag nfcTag, double amount) {
    // TODO: implement increaseBalance
    throw UnimplementedError();
  }

  @override
  Future<NfcState> readTag({required NfcTag nfcTag}) async {
    dynamic mifareTag = MifareUltralight.from(nfcTag);
    if (mifareTag != null) {
      final newState = await NfcNotifierUltralight().readTag(nfcTag: nfcTag);
      state = newState;
    } else {
      final newState = await NfcNotifierClassic().readTag(nfcTag: nfcTag);
      state = newState;
    }
    return state;
  }

  @override
  Future<bool> reduceBalance(NfcTag nfcTag, double amount) async {
    dynamic mifareTag = MifareUltralight.from(nfcTag);
    if (mifareTag != null) {
      return NfcNotifierUltralight().reduceBalance(nfcTag, amount);
    } else {
      return NfcNotifierClassic().reduceBalance(nfcTag, amount);
    }
  }

  @override
  Future<void> setBalance(NfcTag nfcTag, {double balance = 0}) async {
    dynamic mifareTag = MifareUltralight.from(nfcTag);
    if (mifareTag != null) {
      await NfcNotifierUltralight().setBalance(nfcTag);
    } else {
      await NfcNotifierClassic().setBalance(nfcTag);
    }
  }

  @override
  Future<void> setDateTimes(
      NfcTag nfcTag, DateTime? startDate, DateTime? endDate) async {
    dynamic mifareTag = MifareUltralight.from(nfcTag);
    if (mifareTag != null) {
      await NfcNotifierUltralight().setDateTimes(nfcTag, startDate, endDate);
    } else {
      await NfcNotifierClassic().setDateTimes(nfcTag, startDate, endDate);
    }
  }

  @override
  Future<void> setTicketAndEventsIds(
      NfcTag nfcTag, String ticketId, String eventId) async {
    dynamic mifareTag = MifareUltralight.from(nfcTag);
    if (mifareTag != null) {
      await NfcNotifierUltralight()
          .setTicketAndEventsIds(nfcTag, ticketId, eventId);
    } else {
      await NfcNotifierClassic()
          .setTicketAndEventsIds(nfcTag, ticketId, eventId);
    }
  }

  @override
  Future<void> setTitle(NfcTag nfcTag, String title) async {
    dynamic mifareTag = MifareUltralight.from(nfcTag);
    if (mifareTag != null) {
      await NfcNotifierUltralight().setTitle(nfcTag, title);
    } else {
      await NfcNotifierClassic().setTitle(nfcTag, title);
    }
  }

  void reset() {
    state = NfcState();
  }
}

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState?>((ref) {
  return NfcNotifier();
});
