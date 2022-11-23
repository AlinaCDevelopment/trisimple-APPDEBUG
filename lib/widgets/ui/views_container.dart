import '../../helpers/size_helper.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/assets_routes.dart';
import '../../constants/colors.dart';
import '../../constants/decorations.dart';

class ViewContainer extends ConsumerWidget {
  const ViewContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: backgroundDecoration,
      constraints: const BoxConstraints.expand(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context).platform,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'DEVELOPMENT',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
              child: child,
            ),
          ),
          FittedBox(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding:
                      EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.09),
                  child: Center(
                    child: Text(
                      '${AppLocalizations.of(context).version}: 1.0.0',
                      style: TextStyle(fontSize: 11, color: thirdColor),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class SimpleViewContainer extends ConsumerWidget {
  const SimpleViewContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: primaryColor,
      constraints: const BoxConstraints.expand(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context).platform,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'DEVELOPMENT',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
              child: child,
            ),
          ),
          FittedBox(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding:
                      EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.09),
                  child: Center(
                    child: Text(
                      '${AppLocalizations.of(context).version}: 1.0.0',
                      style: TextStyle(fontSize: 11, color: thirdColor),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
