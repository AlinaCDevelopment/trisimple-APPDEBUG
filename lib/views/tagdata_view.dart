import 'package:app_debug/helpers/size_helper.dart';
import 'package:http/retry.dart';

import '../providers/nfc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagDataView extends ConsumerWidget {
  TagDataView(
    this.tagData, {
    super.key,
  });

  ///const name used for routinh
  static const name = 'tagdata';

  ///the data of the tag read that this view will display
  final NfcState tagData;

  final double _textSize = 15;
  final _categoryStyle = TextStyle(fontSize: 17, color: Colors.amber);

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
                  '1 - Dados pulseira:',
                  style: _categoryStyle,
                ),
                Text(
                  tagData.specs ?? '',
                  style: TextStyle(fontSize: _textSize),
                ),
                if (tagData.tag != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2 - Bilhete escrito:',
                        style: _categoryStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Titulo: ${tagData.tag!.title}'),
                      Text('Date inicio: ${tagData.tag!.startDate}'),
                      Text('Date fim: ${tagData.tag!.endDate}'),
                      Text('Id bilhete: ${tagData.tag!.ticketId}'),
                      Text('Id evento: ${tagData.tag!.eventID}'),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                Text(
                  '3 - Bytes:',
                  style: _categoryStyle,
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
    final _byteBlockSize = 16;
    List<Widget> rows = List<Widget>.empty(growable: true);
    for (int sectorIndex = 0;
        sectorIndex < tagData.bytesRead!.length;
        sectorIndex++) {
      final separatedBytes = _separateList(
          tagData.bytesRead![sectorIndex].toList(), _byteBlockSize);

      rows.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'SECTOR: $sectorIndex - BYTES (${sectorIndex * (16 * 4)}-${sectorIndex * (16 * 4) + (16 * 4) - 1})',
            style: TextStyle(color: Colors.red, fontSize: _textSize),
          ),
          Text(
            'CHARS: ${String.fromCharCodes(tagData.bytesRead![sectorIndex])}',
            style: TextStyle(
                color: Color.fromARGB(255, 175, 255, 95), fontSize: _textSize),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: separatedBytes.map((byteGroup) {
                final blockIndex = separatedBytes.indexOf(byteGroup);
                final totalBlockIndex = blockIndex + ((sectorIndex) * 4);
                final bytesRange =
                    '(${blockIndex * 16}-${blockIndex * 16 + 15})';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (blockIndex != 3)
                        ? (blockIndex == 0 && sectorIndex == 0)
                            ? Text(
                                'BLOCK 0-0 (0-15) - MANUFACTURER BLOCK',
                                style: TextStyle(
                                    color: Colors.yellow, fontSize: _textSize),
                              )
                            : Text(
                                'BLOCK ${blockIndex}-${totalBlockIndex} $bytesRange ',
                                style: TextStyle(
                                    color: Colors.yellow, fontSize: _textSize),
                              )
                        : Text(
                            'BLOCK 3-${totalBlockIndex} $bytesRange - SECTOR TRAILER $sectorIndex',
                            style: TextStyle(
                                color: Colors.yellow, fontSize: _textSize),
                          ),
                    SizedBox(
                      width: SizeConfig.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(byteGroup.toString()),
                          //TODO WRITE AND GET NEEDED TAG VALUES IN 1K AND CREATE NEW BRANCHES FOR THE OTHER APPS WITH 1K
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              String.fromCharCodes(byteGroup),
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: _textSize - 5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList()),
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
