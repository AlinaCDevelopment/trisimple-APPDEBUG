import 'package:flutter/material.dart';

@immutable
class EventTag {
  final DateTime startDate;
  final DateTime endDate;
  final String physycalId;
  final int eventID;
  final int ticketId;
  final String title;

  const EventTag(this.physycalId, this.eventID, this.ticketId,
      {required this.startDate, required this.endDate, required this.title});
}
