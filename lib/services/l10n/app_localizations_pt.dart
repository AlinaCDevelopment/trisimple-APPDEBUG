import 'app_localizations.dart';

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get search => 'Procurar';

  @override
  String get version => 'versão';

  @override
  String get tryAgain => 'Tente Novamente.';

  @override
  String get connectionError => 'Erro de Ligação!';

  @override
  String get exit => 'SAIR';

  @override
  String get scan => 'SCAN';

  @override
  String get pendingRecords => 'Registos Pendentes';

  @override
  String get badConnection => 'Ligação falhou';

  @override
  String get rightConnection => 'Ligado';

  @override
  String get platform => 'Plataforma';

  @override
  String get contactsLabel => 'Contato responsável técnico\ndo evento para pedido de suporte:';

  @override
  String get passwordHint => 'Insere a palavra-passe';

  @override
  String get signIn => 'Registar';

  @override
  String get wrongPassword => 'A password inserida não está correta,\ntenta novamente.';

  @override
  String get fillAllFields => 'Todos os campos são obrigatórios,\ntenta novamente.';

  @override
  String get reservedArea => 'Área Reservada';

  @override
  String get authorizedPeople => 'Só é permitida a entrada a pessoas autorizadas pela Trisimple';

  @override
  String get emailLabel => 'Para mais informações envie email para:';

  @override
  String get codeInsertLabel => 'Inserir CÓDIGO gravado no Chip da pulseira';

  @override
  String get condeInsertHint => 'Insere o código';

  @override
  String get approachNfc => 'Pode aproximar.';

  @override
  String get unavailableNfc => 'NFC INDISPONÍVEL';

  @override
  String get valid => 'VÁLIDO';

  @override
  String get invalid => 'INVÁLIDO';

  @override
  String get ticket => 'Bilhete';

  @override
  String get bracelet => 'Pulseira';

  @override
  String get error => 'Erro';
}
