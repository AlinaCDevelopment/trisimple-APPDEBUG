import 'dart:developer';

import '../services/l10n/app_localizations.dart';
import '../views/search_view.dart';
import '../widgets/nfc_scanner..dart';
import '../widgets/themed_button.dart';
import '../providers/nfc_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/assets_routes.dart';
import '../constants/colors.dart';
import '../screens/container_screen.dart';
import '../widgets/ui/dialog_messages.dart';
import '../widgets/ui/views_container.dart';
import 'tagdata_view.dart';

class ScanView extends ConsumerWidget {
  ScanView({super.key});

  static const name = 'scan';
  Widget? body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(nfcProvider);
    ref.listen(nfcProvider, (previous, next) async {
      if (next != null && next.error != null && next.error!.isNotEmpty ||
          next != null && next.specs != null && next.bytesRead!.isNotEmpty) {
        print('nfc state changed');
        if (next.error != null && next.error!.isNotEmpty) {
          body = _buildScanningView();
          showMessageDialog(
              context,
              ScanErrorMessage(
                message: next.error,
              ));
        } else {
          print('data detected');
          body = _buildTagDataView(next);
          print('body created');
        }
      } else {
        body = _buildScanningView();
      }
    });
    print('body: $body');
    return body ?? _buildScanningView();
  }

  Stack _buildTagDataView(NfcState tagFound) {
    return Stack(
      children: [
        TagDataView(tagFound!),
        Align(
          alignment: Alignment.topRight,
          child: Consumer(
            builder: (context, ref, child) => IconButton(
              onPressed: (() => ref.read(nfcProvider.notifier).reset()),
              icon: Icon(
                Icons.keyboard_return,
                color: Colors.white,
              ),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  ViewContainer _buildScanningView() {
    return ViewContainer(
      child: Consumer(
        builder: (context, ref, child) {
          return NfcScanner(
              /*   nfcAction: () =>
                ref.read(nfcProvider.notifier).readTagInSession(context), */
              );
        },
      ),
    );
  }
}
