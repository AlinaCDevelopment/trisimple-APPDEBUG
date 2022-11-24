import 'package:app_debug/screens/container_screen.dart';
import 'package:app_debug/views/scan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/nfc_provider.dart';

class WriteView extends ConsumerStatefulWidget {
  static const name = 'writeView';

  @override
  ConsumerState<WriteView> createState() => _WriteViewState();
}

class _WriteViewState extends ConsumerState<WriteView> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    ref.read(nfcProvider.notifier).testWrie();

    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            setState(() {
              text = value;
            });
          },
        ),
        ElevatedButton(onPressed: (() async {}), child: Text('Write TicketId'))
      ],
    );
  }
}
