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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagFound = ref.watch(nfcProvider);
    if (tagFound != null && tagFound.error != null ||
        tagFound != null && tagFound.specs != null) {
      if (tagFound.error != null && tagFound.error!.isNotEmpty) {
        showMessageDialog(
            context,
            ScanErrorMessage(
              message: tagFound.error,
            ));
      } else {
        if (tagFound.specs != null) {
          return _buildTagDataView(tagFound, ref);
        }
      }
    }

    return _buildScanningView(ref);
  }

  Stack _buildTagDataView(NfcState tagFound, WidgetRef ref) {
    return Stack(
          children: [
            TagDataView(tagFound!),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: (() => ref.read(nfcProvider.notifier).reset()),
                icon: Icon(
                  Icons.keyboard_return,
                  color: Colors.white,
                ),
                color: Colors.white,
              ),
            ),
          ],
        );
  }

  ViewContainer _buildScanningView(WidgetRef ref) {
    return ViewContainer(
    child: Builder(
      builder: (context) {
        return FutureBuilder(
          future: ref.read(nfcProvider.notifier).isNfcAvailable(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if ((snapshot.data!)) {
                ref.read(nfcProvider.notifier).readTagInSession(context);
                // ref.read(nfcProvider.notifier).readClassicTag();

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildScanImage(context),
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 60.0, left: 60.0, bottom: 10, top: 10),
                        child: ThemedButton(
                            onTap: () => ref
                                .read(viewProvider.notifier)
                                .state = SearchView.name,
                            text: AppLocalizations.of(context).search)),
                  ],
                );
              } else {
                return Center(
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
                ));
              }
            }
            return Container();
          },
        );
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
