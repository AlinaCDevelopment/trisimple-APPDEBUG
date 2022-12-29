import 'dart:ui';

import '../../constants/assets_routes.dart';

import 'package:flutter/material.dart';

import '../../helpers/size_helper.dart';
import '../../models/event_tag.dart';
import '../../services/l10n/app_localizations.dart';

class ScanErrorMessage extends StatelessWidget {
  const ScanErrorMessage({this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return ScanDialogMessage(
        title: AppLocalizations.of(context).error,
        content: message != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  message!,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              )
            : null,
        assetPngImgName: errorImgRoute);
  }
}

class ScanDialogMessage extends StatelessWidget {
  const ScanDialogMessage(
      {super.key,
      required this.title,
      this.content,
      required this.assetPngImgName});
  final String title;
  final Widget? content;
  final String assetPngImgName;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: SizeConfig.screenHeight * 0.66,
            width: SizeConfig.screenWidth * 0.85,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.screenWidth * 0.2,
                            left: SizeConfig.screenWidth * 0.2,
                            top: 50),
                        child: Image.asset(assetPngImgName),
                      ),
                      Text(
                        title,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 40),
                      ),
                      content ?? Container()
                    ]),
              ],
            )));
  }
}

class DialogMessage extends StatelessWidget {
  const DialogMessage({super.key, required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: SizeConfig.screenHeight * 0.25,
            width: SizeConfig.screenWidth * 0.85,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(255, 29, 29, 29)
                                .withOpacity(0.7),
                            fontSize: 30),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: FittedBox(
                          child: Text(
                            content,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(115, 14, 14, 14),
                                fontSize: 20),
                          ),
                        ),
                      )
                    ]),
              ],
            )));
  }
}

Future<T?> showMessageDialog<T>(BuildContext context, Widget message) async {
  if (ModalRoute.of(context)?.isCurrent != true && Navigator.canPop(context)) {
    Navigator.pop(context);
  }
  return await showDialog<T>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: message);
    },
  );
}
