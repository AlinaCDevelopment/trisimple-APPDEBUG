import '../views/search_view.dart';
import '../widgets/themed_button.dart';
import '../providers/nfc_provider.dart';
import 'package:flutter/material.dart';

import '../services/translation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/assets_routes.dart';
import '../constants/colors.dart';
import '../screens/container_screen.dart';
import '../widgets/ui/dialog_messages.dart';
import '../widgets/ui/views_container.dart';
import 'tagdata_view.dart';

class ScanView extends ConsumerWidget {
  const ScanView({super.key});

  static const name = 'scan';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NfcState? tagFound = ref.watch(nfcProvider);
    if (tagFound != null &&
        tagFound.error != null &&
        tagFound.error!.isNotEmpty) {
      print('ERR: ');
      print(tagFound.error);
    }
/* 
    ref.listen(nfcProvider, (previous, next) async {
      if (next != null && next.error != null ||
          next != null && next.tag != null) {
        if (next.error != null && next.error!.isNotEmpty) {
          showMessageDialog(context, ScanErrorMessage(context));
        } else {
          tagFound = next;
        }
      }
    }); */
    return tagFound?.specs != null
        ? Stack(
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
          )
        : ViewContainer(
            child: Builder(
              builder: (context) {
                return FutureBuilder(
                  future: ref.read(nfcProvider.notifier).isNfcAvailable(),
                  builder: (context, snapshot) {
                    Widget? bodyPresented;
                    if (snapshot.hasData && snapshot.data != null) {
                      //REAL VERSION
                      if ((snapshot.data!)) {
                        ref.read(nfcProvider.notifier).readTagInSession();
                        // ref.read(nfcProvider.notifier).readClassicTag();

                        bodyPresented = Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Expanded(child: ScranImage()),
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
                                    text: MultiLang.texts.search)),
                          ],
                        );
                        //TEST VERSION
                        /*
              if ((true)) {
                bodyPresented = GestureDetector(
                    onTap: () {
                      ref.read(nfcProvider.notifier).setDumbError();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      Expanded(child: const ScranImage()),
                      Padding(
                          padding: const EdgeInsets.only(
                              right: 60.0, left: 60.0, bottom: 10, top: 10),
                          child: ThemedButton(
                              onTap: () => ref
                                  .read(viewProvider.notifier)
                                  .setView(SearchView.name),
                              text: MultiLang.texts.search)),
                    ],
                    ));*/
                      } else {
                        bodyPresented = Center(
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          child: Text(
                            MultiLang.texts.unavailableNfc,
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
                    return bodyPresented ?? Container();
                  },
                );
              },
            ),
          );
  }
}

class ScranImage extends StatelessWidget {
  const ScranImage({
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
                MultiLang.texts.approachNfc,
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
