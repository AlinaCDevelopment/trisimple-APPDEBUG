import 'package:app_debug/helpers/size_helper.dart';
import 'package:app_debug/screens/container_screen.dart';
import 'package:app_debug/views/scan_view.dart';
import 'package:app_debug/views/tagdata_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../providers/nfc_provider.dart';

class WriteView extends ConsumerStatefulWidget {
  static const name = 'writeView';

  @override
  ConsumerState<WriteView> createState() => _WriteViewState();
}

class _WriteViewState extends ConsumerState<WriteView> {
  String _ticketId = '';
  String _eventId = '';
  String _title = '';
  DateTime? _firstDate;
  DateTime? _lastDate;

  @override
  Widget build(BuildContext context) {
    final nfcState = ref.watch(nfcProvider);
    return Container(
      color: Color.fromARGB(255, 27, 27, 27),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(label: Text('ID Bilhete')),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(20),
            ],
            onChanged: (value) {
              setState(() {
                _ticketId = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(label: Text('ID Evento')),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(20),
            ],
            onChanged: (value) {
              setState(() {
                _eventId = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(label: Text('Título Bilhete')),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(40),
            ],
            onChanged: (value) {
              setState(() {
                _title = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: (() async {
                    final date = await _getDateTime();
                    if (date != null) {
                      setState(() => _firstDate = date);
                    }
                  }),
                  child: Text('Start date')),
              Text('$_firstDate')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: (() async {
                    final date = await _getDateTime();
                    if (date != null) {
                      setState(() => _lastDate = date);
                    }
                  }),
                  child: Text('End date')),
              Text('$_lastDate')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: _storeDataToTag, child: Text('Write Data')),
              ElevatedButton(
                  onPressed: (() async {
                    ref.read(nfcProvider.notifier).inSession(
                      context,
                      onDiscovered: (nfcTag) async {
                        await ref.read(nfcProvider.notifier).clearTag(nfcTag);
                      },
                    );
                  }),
                  child: Text('Wipe Tag')),
            ],
          ),
          if (nfcState != null &&
              nfcState.bytesRead != null &&
              nfcState.bytesRead!.isNotEmpty)
            Expanded(child: TagDataView(nfcState)),
        ],
      ),
    );
  }

  _storeDataToTag() async {
    await ref.read(nfcProvider.notifier).inSession(context,
        onDiscovered: (nfcTag) async {
      try {
        if (_title.isNotEmpty)
          await ref.read(nfcProvider.notifier).setTitle(nfcTag, _title);
        if (_ticketId.isNotEmpty && _eventId.isNotEmpty)
          await ref
              .read(nfcProvider.notifier)
              .setTicketAndEventsIds(nfcTag, _ticketId, _eventId);
        if (_firstDate != null && _lastDate != null) {
          await ref
              .read(nfcProvider.notifier)
              .setDateTimes(nfcTag, _firstDate!, _lastDate!);
        }
        await ref.read(nfcProvider.notifier).readTag(nfcTag: nfcTag);
      } catch (e) {
        print('error writing!\n$e');
        if (e is PlatformException) {
          print(e.code);
          print(e.message);
          print(e.details);
          print(e.stacktrace);
        }
      }
    });
  }

  Future<DateTime?> _getDateTime() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate:
            DateTime(DateTime.now().year + 1).subtract(Duration(days: 1)));
    final time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (date != null && time != null) {
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }
  }
}
