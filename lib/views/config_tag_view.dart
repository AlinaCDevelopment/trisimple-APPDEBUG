import 'dart:io';

import 'package:app_debug/models/configuracaoBilhete.dart';
import 'package:app_debug/models/evento.dart';
import 'package:app_debug/models/pulseira.dart';
import 'package:app_debug/screens/themed_input.dart';
import 'package:app_debug/services/database_service.dart';
import 'package:app_debug/services/wifi_verification.dart';
import 'package:app_debug/widgets/nfc_scanner..dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/nfc_provider.dart';

import '../providers/nfc_provider.dart';
import '../widgets/ui/dialog_messages.dart';

class ConfigTagView extends ConsumerStatefulWidget {
  ConfigTagView({super.key});
  static const name = 'config_tag';

  @override
  ConsumerState<ConfigTagView> createState() => _ConfigTagViewState();
}

class _ConfigTagViewState extends ConsumerState<ConfigTagView> {
  String _nome = '';

  List<ConfiguracaoBilhete> _configs = List<ConfiguracaoBilhete>.empty();
  List<Evento> _eventos = List<Evento>.empty();

  int? _configSelectedId;

  int? _eventoSelectedId;
  Pulseira? _pulseira;

  String? _internalBraceletId;
  String? validTagText;
  String? invalidTagText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasWifi = await checkWifiWithValidation(context);
      if (hasWifi) {
        _eventos = (await DatabaseService.instance.getEventos());
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(nfcProvider, (previous, next) async {
      if (next != null) {
        if (next.error != null && next.error!.isNotEmpty) {
          showMessageDialog(
              context,
              ScanErrorMessage(
                message: next.error,
              ));
        } else {
          if (next.internalId != null) {
            print(next.internalId);
            if (next.bilhete == null) {
              final pulseira = await DatabaseService.instance
                  .getBraceletByInternalId(next.internalId!);
              if (pulseira != null) {
                setState(() {
                  _pulseira = pulseira;

                  validTagText = 'Tag identified';
                });
              } else {
                setState(() {
                  invalidTagText = 'This bracelet is not in our systems';
                });
              }
            } else {
              setState(() {
                invalidTagText =
                    'This bracelet has already been assigned to a ticket';
              });
            }
          }
        }
      }
    });
    return Column(
      children: [
        ThemedInput(onChanged: (value) => _nome = value, hintText: 'Nome'),
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              itemHeight: 50,
              onTap: () {
                final hasWifi = checkWifiWithValidation(context);
                try {
                  DatabaseService.instance.getEventos().then((value) {
                    _eventos = value;
                    setState(() {});
                  });
                } on SocketException {
                  showWifiErrorMessage(context);
                }
              },
              value: _eventoSelectedId,
              isExpanded: true,
              hint: Text('Eventos'),
              items: _eventos
                  .map((e) => DropdownMenuItem(
                        child: Text(e.nome),
                        value: e.id,
                      ))
                  .toList(),
              onChanged: ((value) async {
                setState(() {
                  _configs = List.empty();
                  _eventoSelectedId = value;
                });
                if (value != null) {
                  final hasWifi = checkWifiWithValidation(context);
                  try {
                    _configs = await DatabaseService.instance.getConfigs(value);
                    setState(() {});
                  } on SocketException {
                    showWifiErrorMessage(context);
                  }
                }
              }),
              icon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_drop_down),
              ),
              iconEnabledColor: Theme.of(context).iconTheme.color,
              iconDisabledColor: Theme.of(context).iconTheme.color,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              itemHeight: 50,
              value: _configSelectedId,
              isExpanded: true,
              hint: Text('Config'),
              items: _configs
                  .map((e) => DropdownMenuItem(
                        child: Text(e.titulo),
                        value: e.id,
                      ))
                  .toList(),
              onChanged: ((value) {
                if (value != null) {
                  _configSelectedId = value;
                  setState(() {});
                }
              }),
              icon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_drop_down),
              ),
              iconEnabledColor: Theme.of(context).iconTheme.color,
              iconDisabledColor: Theme.of(context).iconTheme.color,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(child: NfcScanner()),
              if (validTagText != null)
                Text(
                  validTagText!,
                  style: TextStyle(color: Colors.green),
                ),
              if (invalidTagText != null)
                Text(
                  invalidTagText!,
                  style: TextStyle(color: Colors.red),
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () async {
                if (_eventoSelectedId != null &&
                    _configSelectedId != null &&
                    _pulseira != null &&
                    _nome.trim().isNotEmpty) {
                  //If the event id i +s null the bracelets can be assigned to any event because they are trisimple bracelets
                  if (_pulseira!.id_evento == null ||
                      _pulseira!.id_evento == _eventoSelectedId) {
                    final ticketCreated = await DatabaseService.instance
                        .genDebugTicket(_eventoSelectedId!, _configSelectedId!,
                            _pulseira!.id, _nome.trim());
                    //TODO WAIT FOR XD
                    //TODO INCREMENT DECREMENT SALDO
                    //TODO use bilhetes-esntl to get the bilhete
                    /*  final bilhete = await DatabaseService.instance
                        .getBilheteBy(_pulseira!.id_interno)!;
                    if (ticketCreated) {
                      Navigator.push(context, ticketId: bilhete.id, route);
                    } */
                    //Do not have the next screen have an appbar

                    //TODO INSTEAD OF PUTTING A BUTTON ON THIS, HAVE THE USER FILL THE OTHER FIELDS BEFORE SCANNING THE TAG, AND WHEN YOU SCAN THE TAG TO GET PHYSICAL ID, WRITE THE DATA AT ONCE
                  } else {}
                }
              },
              child: Text('Submeter dados')),
        )
      ],
    );
  }
}
