import 'package:app_debug/helpers/size_helper.dart';
import 'package:app_debug/screens/container_screen.dart';
import 'package:app_debug/views/scan_view.dart';
import 'package:app_debug/views/tagdata_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../providers/nfc_provider.dart';

class WriteView extends ConsumerStatefulWidget {
  static const name = 'writeView';

  @override
  ConsumerState<WriteView> createState() => _WriteViewState();
}

class _WriteViewState extends ConsumerState<WriteView> {
  String _ticketId = '';
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
                    ref.read(nfcProvider.notifier).clearTagInSession(context);
                  }),
                  child: Text('WIPE TAG')),
            ],
          ),
          if (nfcState != null &&
              nfcState.bitesRead != null &&
              nfcState.bitesRead!.isNotEmpty)
            Expanded(child: TagDataView(nfcState)),
        ],
      ),
    );
  }

  _storeDataToTag() async {
    await ref.read(nfcProvider.notifier).inSession(context,
        onDiscovered: (nfcTag, mifareTag) async {
      await ref.read(nfcProvider.notifier).setTicketId(mifareTag, _ticketId);
      if (_firstDate != null && _lastDate != null) {
        await ref
            .read(nfcProvider.notifier)
            .setDateTimes(mifareTag, _firstDate!, _lastDate!);
      }
      await ref
          .read(nfcProvider.notifier)
          .readTag(mifareTag: mifareTag, nfcTag: nfcTag);
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
