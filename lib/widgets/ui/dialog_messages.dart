import 'dart:ui';

import 'package:app_4/constants/assets_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../helpers/size_helper.dart';
import '../../models/event_tag.dart';

class ScanErrorMessage extends StatelessWidget {
  ScanErrorMessage(this.parentContext);
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return ScanDialogMessage(
        title: AppLocalizations.of(context).error,
        assetPngImgName: errorImgRoute);
  }
}

class ScanValidationMessage extends StatelessWidget {
  const ScanValidationMessage(
    this.parentContext, {
    Key? key,
    required this.eventTag,
  }) : super(key: key);

  final EventTag eventTag;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    final availability =
        _checkTagValidity(eventTag.startDate, eventTag.endDate);
    final durationDays = eventTag.endDate.day - eventTag.startDate.day + 1;

    final validationText = availability
        ? AppLocalizations.of(context).valid
        : AppLocalizations.of(context).invalid;
    String durationText;

    if (eventTag.endDate.difference(eventTag.startDate).inDays > 0) {
      durationText = 'Bilhete Passe $durationDays Dias';
    } else {
      durationText =
          'Bilhete Diário ${eventTag.startDate.day} ${_getMonth(eventTag.startDate.month)} ${eventTag.startDate.year}';
    }
    final datesInfoText = 'Das ${eventTag.startDate.hour}h do dia ' +
        '${eventTag.startDate.day}-${eventTag.startDate.month}-${eventTag.startDate.year}, ' +
        'até ${eventTag.startDate.hour}h do dia ' +
        '${eventTag.endDate.day}-${eventTag.endDate.month}-${eventTag.endDate.year}';
    return ScanDialogMessage(
      assetPngImgName: availability ? validImgRoute : invalidImgRoute,
      title: validationText,
      content: Column(children: [
        FittedBox(
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                durationText,
                style: const TextStyle(color: Colors.grey, fontSize: 23),
              ),
              Text(
                textAlign: TextAlign.center,
                datesInfoText,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: QrImage(
                    data: "1234567890",
                    version: QrVersions.auto,
                    //size: 200.0,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).ticket,
                  style: const TextStyle(fontSize: 17, color: Colors.black54),
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: QrImage(
                    data: "1234567890",
                    version: QrVersions.auto,
                    //size: 200.0,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).bracelet,
                  style: const TextStyle(fontSize: 17, color: Colors.black54),
                )
              ],
            ),
          ],
        )
      ]),
    );
  }
}

bool _checkTagValidity(DateTime startDate, DateTime lastDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  //TODO INCLUDE HOUR AND MINUTES
  return startDate.isBefore(today) && lastDate.isAfter(today) ||
      startDate.isBefore(today) && lastDate.isAtSameMomentAs(today) ||
      startDate.isAtSameMomentAs(today) && lastDate.isAfter(today) ||
      startDate.isAtSameMomentAs(today) && lastDate.isAtSameMomentAs(today);
}

//TODO REMOVE THIS WHEN DB IS READY
String _getMonth(int month) {
  switch (month) {
    case 1:
      return 'Janeiro';
    case 2:
      return 'Fevereiro';
    case 3:
      return 'Março';
    case 4:
      return 'Abril';
    case 5:
      return 'Maio';
    case 6:
      return 'Junho';
    case 7:
      return 'Julho';
    case 8:
      return 'Agosto';
    case 9:
      return 'Setembro';
    case 10:
      return 'Outubro';
    case 11:
      return 'Novembro';
    default:
      return 'Dezembro';
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
                    //TODO Use Icon
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
  return await showDialog<T>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: message);
    },
  );
}
