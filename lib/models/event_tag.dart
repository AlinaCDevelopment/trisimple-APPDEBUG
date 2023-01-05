import 'package:flutter/material.dart';

@immutable
class Bilhete {
  final DateTime startDate;
  final DateTime endDate;
  final String internalId;
  final int eventID;
  final int ticketId;
  final double balance;
  final String title;

  const Bilhete(this.internalId, this.eventID, this.ticketId,
      {required this.startDate,
      required this.balance,
      required this.endDate,
      required this.title});
}
