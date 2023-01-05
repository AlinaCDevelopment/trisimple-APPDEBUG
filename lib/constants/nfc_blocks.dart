import 'dart:typed_data';
import 'package:flutter/material.dart';

//Default value for KeyB Classic 1k tags
final defaultkeyB = Uint8List.fromList([255, 255, 255, 255, 255, 255]);
//Default value for KeyA Classic 1k tags
final defaultkeyA = Uint8List.fromList([0, 0, 0, 0, 0, 0]);

//KeyB to authenticate into our NFC Tags
final keyB = Uint8List.fromList([255, 255, 255, 255, 255, 255]);
//KeyA to authenticate into our NFC Tags
final keyA = Uint8List.fromList([0, 0, 0, 0, 0, 0]);

///Indication to the place where to store data inside NFC Event tags that hold tickets
@immutable
class NfcStorageSlot {
  final int sector;
  final List<int> blocksInSector;

  const NfcStorageSlot(this.sector, this.blocksInSector);
}

///The storage slot for the ticket title
const titleStorage = NfcStorageSlot(2, [0, 1, 2]);

///The storage slot for the ids of the ticket and of the vent
///
///The 16 bytes of the block is in this case devided for both ids:
/// 1st 8 bytes of the single value in [blocksInSector] are assigned to the ticketId
/// 2nd 8 bytes of the single value in [blocksInSector] are assigned to the eventId
const ticketIdEventIdStorage = NfcStorageSlot(0, [1]);

///The storage slot for the ticket's balance/saldo
const balanceStorage = NfcStorageSlot(0, [2]);

///The storage slot for the ticket's start date
const starttDateStorage = NfcStorageSlot(1, [0]);

///The storage slot for the ticket's end date
const endDateStorage = NfcStorageSlot(1, [1]);

///The storage slot for the ticket's manufacturerblock which serves as the id
const manufacturerBlockStorage = NfcStorageSlot(0, [0]);
