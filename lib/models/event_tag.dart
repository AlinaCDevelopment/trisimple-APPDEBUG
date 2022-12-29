import 'package:flutter/material.dart';

@immutable
class EventTag {
  final DateTime startDate;
  final DateTime endDate;
  final String physycalId;
  final String eventID;
  final String ticketId;

  const EventTag(this.physycalId, this.eventID, this.ticketId,
      {required this.startDate, required this.endDate});
}
