import '../services/l10n/app_localizations.dart';
import '../views/search_view.dart';
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
      child: Builder(
        builder: (context) {
          return Consumer(
              builder: (_, ref, unavailableNFC) {
                return FutureBuilder(
                  future: ref.read(nfcProvider.notifier).isNfcAvailable(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      if ((snapshot.data!)) {
                        ref
                            .read(nfcProvider.notifier)
                            .readTagInSession(context);
                        // ref.read(nfcProvider.notifier).readClassicTag();

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildScanImage(context),
                            Padding(
                                padding: const EdgeInsets.only(
                                    right: 60.0,
                                    left: 60.0,
                                    bottom: 10,
                                    top: 10),
                                child: ThemedButton(
                                    onTap: () => ref
                                        .read(viewProvider.notifier)
                                        .state = SearchView.name,
                                    text: AppLocalizations.of(context).search)),
                          ],
                        );
                      } else {
                        return unavailableNFC!;
                      }
                    }
                    return Container();
                  },
                );
              },
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Text(
                  AppLocalizations.of(context).unavailableNfc,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      shadows: [
                        Shadow(offset: Offset(1, 1)),
                        Shadow(offset: Offset(1, -1))
                      ]),
                ),
              )));
        },
      ),
    );
  }

  Widget _buildScanImage(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Center(child: Image.asset(overlayCirlcedImgRoute)),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(49.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Image.asset(scanImgRoute),
              Text(
                AppLocalizations.of(context).approachNfc,
                style: const TextStyle(fontSize: 22, color: backMaterialColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
