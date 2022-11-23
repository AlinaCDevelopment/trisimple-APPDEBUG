import 'package:app_debug/helpers/size_helper.dart';

import '../providers/nfc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagDataView extends ConsumerWidget {
  const TagDataView({super.key});
  static const name = 'tagdata';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagData = ref.watch(nfcProvider)!;
    ref.read(nfcProvider.notifier).readTag();
    return Container(
      color: Colors.black,
      width: SizeConfig.screenWidth,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Especificações: \n${tagData.specs}\n\n'),
            Text('Identifier: ${tagData.identifier}'),
            Text('ATQA: ${tagData.atqa}'),
            Text('MaxTransceiveLenght: ${tagData.maxTransceiveLenght}'),
            Text('Timeout: ${tagData.timeout}'),
            Text('Bites:'),
            ...tagData.bitesRead!.map((biteText) => Column(
                  children: [
                    Text(biteText),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
