import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:nfc_manager/platform_tags.dart' as tags;
import '../models/event_tag.dart';
import '../services/l10n/app_localizations.dart';

@immutable
class NfcState {
  final Bilhete? bilhete;
  final String? internalId;
  final List<Iterable<int>>? bytesRead;
  final String? error;
  final String? specs;
  final String? handle;

  const NfcState({
    this.bilhete,
    this.bytesRead,
    this.internalId,
    this.error,
    this.specs,
    this.handle,
  });
}

@immutable
abstract class NfcNotifierBase extends StateNotifier<NfcState> {
  NfcNotifierBase() : super(const NfcState());

  //==================================================================================================================
  //MAIN METHODS

  ///Reads data from [mifareTag] and [nfcTag] and sets the provider's state from it
  Future<NfcState> readTag({
    required NfcTag nfcTag,
  });

  ///Cleats any data possibly written by the trisimple apps inside [mifareTag]
  ///This sets most of its bytes to 0
  Future<void> clearTag(NfcTag nfcTag);

  ///Reduces from the [balance] of the [Bilhete] stored in the [mifareTag] the [amount] specified
  ///
  ///Returns false if the [balance] insde the [mifareTag] is smaller than [amount]
  Future<bool> reduceBalance(NfcTag nfcTag, double amount);

  ///Adds to the [balance] of the [Bilhete] stored in the [mifareTag] the [amount] specified
  Future<void> increaseBalance(NfcTag nfcTag, double amount);
  Future<void> setDateTimes(
      NfcTag nfcTag, DateTime? startDate, DateTime? endDate);

  /// Stores the [ticketId] in the [mifareTag]
  Future<void> setTicketAndEventsIds(
      NfcTag nfcTag, String ticketId, String eventId);

  /// Stores the [ticketId] in the [mifareTag]
  Future<void> setBalance(NfcTag nfcTag, {double balance = 0});

  Future<void> setTitle(NfcTag nfcTag, String title);
}
