import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/assets_routes.dart';
import '../constants/colors.dart';

import '../providers/nfc_provider.dart';
import '../screens/container_screen.dart';
import '../services/l10n/app_localizations.dart';
import '../views/search_view.dart';
import 'themed_button.dart';

class NfcScanner extends StatelessWidget {
  const NfcScanner({
    Key? key,
    /* required this.nfcAction */
  }) : super(key: key);
  // final VoidCallback nfcAction;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Consumer(
            builder: (_, ref, unavailableNFC) {
/*               return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: ScanImage(),
                    onTap: () {
                      ref
                        .read(nfcProvider.notifier)
                        .readTagInSession(context);
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          right: 60.0, left: 60.0, bottom: 10, top: 10),
                      child: ThemedButton(
                          onTap: () => ref.read(viewProvider.notifier).state =
                              SearchView.name,
                          text: AppLocalizations.of(context).search)),
                ],
              ); */
              return FutureBuilder(
                future: ref.read(nfcProvider.notifier).isNfcAvailable(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if ((snapshot.data!)) {
                      //nfcAction.call();
                      ref.read(nfcProvider.notifier).inSession(
                        context,
                        onDiscovered: (nfcTag) async {
                          ref
                              .read(nfcProvider.notifier)
                              .readTag(nfcTag: nfcTag);
                        },
                      );

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            child: ScanImage(),
                            onTap: () {
                              ref.read(nfcProvider.notifier).inSession(
                                context,
                                onDiscovered: (nfcTag) async {
                                  ref
                                      .read(nfcProvider.notifier)
                                      .readTag(nfcTag: nfcTag);
                                },
                              );
                            },
                          ),
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
    );
  }
}

class ScanImage extends StatelessWidget {
  const ScanImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
