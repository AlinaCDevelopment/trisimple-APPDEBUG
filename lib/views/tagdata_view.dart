import 'package:app_debug/helpers/size_helper.dart';
import 'package:http/retry.dart';

import '../providers/nfc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagDataView extends ConsumerWidget {
  const TagDataView(
    this.tagData, {
    super.key,
  });
  static const name = 'tagdata';
  final NfcState tagData;
  final double _textSize = 15;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.black,
      constraints: BoxConstraints.expand(),
      //width: SizeConfig.screenWidth,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.screenWidth * 0.07,
              right: SizeConfig.screenWidth * 0.07,
              left: SizeConfig.screenWidth * 0.07,
              bottom: SizeConfig.screenWidth * 0.2),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Specs: ${tagData.specs}',
                  style: TextStyle(fontSize: _textSize),
                ),
                Text(
                  'Bites:',
                  style: TextStyle(fontSize: _textSize),
                ),
                if (tagData.bitesRead != null) ..._buildRows(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRows() {
    List<Widget> rows = List<Widget>.empty(growable: true);
    for (int i = 0; i < tagData.bitesRead!.length; i++) {
      rows.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'SLOT: $i - PAGES (${i * 4}-${i * 4 + 3})',
            style: TextStyle(color: Colors.red, fontSize: _textSize),
          ),
          Text(
            'CHARS: ${String.fromCharCodes(tagData.bitesRead![i])}',
            style: TextStyle(color: Colors.yellow, fontSize: _textSize),
          ),
          Row(
            children: [
              Text(tagData.bitesRead![i].toString()),
            ],
          ),
        ],
      ));
    }
    return rows;
  }
}
