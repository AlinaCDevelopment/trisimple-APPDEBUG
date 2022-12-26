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

  ///const name used for routinh
  static const name = 'tagdata';

  ///the data of the tag read that this view will display
  final NfcState tagData;

  final double _textSize = 15;

  //=========================================================================================================================================================
  //BUILD METHOD

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
                if (tagData.bytesRead != null) ..._buildRows(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //=========================================================================================================================================================
  //PRIVATE METHODS

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //UI METHODS
  List<Widget> _buildRows() {
    final _byteGroupsLentgh = 8;
    List<Widget> rows = List<Widget>.empty(growable: true);
    for (int i = 0; i < tagData.bytesRead!.length; i++) {
      final separatedBytes =
          _separateList(tagData.bytesRead![i].toList(), _byteGroupsLentgh);

      rows.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'SLOT: $i - BYTES (${i * 16}-${i * 16 + 15})',
            style: TextStyle(color: Colors.red, fontSize: _textSize),
          ),
          Text(
            'CHARS: ${String.fromCharCodes(tagData.bytesRead![i])}',
            style: TextStyle(color: Colors.yellow, fontSize: _textSize),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: separatedBytes
                  .map((byteGroup) => Text(byteGroup.toString()))
                  .toList()),
        ],
      ));
    }
    return rows;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //DART METHODS
  List<List<T>> _separateList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = List<List<T>>.empty(growable: true);
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }
}
