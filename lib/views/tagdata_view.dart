import 'package:app_debug/helpers/size_helper.dart';

import '../providers/nfc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/ui/dialog_messages.dart';

class TagDataView extends ConsumerWidget {
  const TagDataView(
    this.tagData, {
    super.key,
  });
  static const name = 'tagdata';
  final NfcState tagData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.black,
      constraints: BoxConstraints.expand(),
      //width: SizeConfig.screenWidth,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.screenWidth * 0.07),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Especificações: \n${tagData.specs}\n\n'),
              Text('Specs: ${tagData.specs}'),
              Text('Bites:'),
              if (tagData.bitesRead != null)
                ...tagData.bitesRead!.map((biteText) => Row(
                      children: [
                        Text(biteText.toString()),
                        Text(String.fromCharCodes(biteText))
                      ],
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
