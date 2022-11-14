import 'dart:ui';

import 'package:app_4/widgets/themed_button.dart';
import 'package:app_4/widgets/ui/views_container.dart';

import '../helpers/size_helper.dart';
import '../providers/auth_provider.dart';
import '../providers/nfc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/assets_routes.dart';
import '../constants/colors.dart';
import '../widgets/ui/dialog_messages.dart';

//TODO Fix authentication preferences save

class ScanView extends ConsumerWidget {
  const ScanView(this.parentContext, {super.key});
  final BuildContext parentContext;

  static const name = 'scan';

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(nfcProvider, (previous, next) {
      if (next != null && next.error != null ||
          next != null && next.tag != null) {
        Widget dialog;
        if (next.error != null && next.error!.isNotEmpty) {
          dialog = ErrorMessage(parentContext);
        } else {
          dialog = ValidationMessage(parentContext, eventTag: next.tag!);
        }
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: dialog);
          },
        );
      }
    });
    return FutureBuilder(
      future: ref.read(nfcProvider.notifier).isNfcAvailable(),
      builder: (context, snapshot) {
        Widget? bodyPresented;
        if (snapshot.hasData && snapshot.data != null) {
          //REAL VERSION
            if ((snapshot.data!)) {
              bodyPresented = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const ScranImage(),
         Padding(
          padding: const EdgeInsets.only(right: 60.0, left: 60.0, bottom: 10),
          child: ThemedButton(
        onTap: () {}, text: AppLocalizations.of(context).search),
        ),
      ],
      );
          //TEST VERSION
          //if ((true)) {
          //  bodyPresented = GestureDetector(
          //      onTap: () {
          //        ref.read(nfcProvider.notifier).setDumbPositive();
          //      },
          //      child: nfcUserChild);
          } else {
            bodyPresented = Center(
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
        return bodyPresented ?? Container();
      },
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
