import 'package:flutter/material.dart';

@immutable
class EventTag {
  final DateTime startDate;
  final DateTime endDate;
  final int id;
  final int eventID;

  const EventTag(this.id, this.eventID,
      {required this.startDate, required this.endDate});
}
