import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get search => 'Search';

  @override
  String get version => 'version';

  @override
  String get tryAgain => 'Try Again.';

  @override
  String get connectionError => 'Connection Error!';

  @override
  String get exit => 'Exit';

  @override
  String get scan => 'Scan';

  @override
  String get pendingRecords => 'Pending Records';

  @override
  String get badConnection => 'Connection failed';

  @override
  String get rightConnection => 'Connected';

  @override
  String get platform => 'Plataform';

  @override
  String get contactsLabel => 'Contact of the technician\nin charge of the event for support:';

  @override
  String get passwordHint => 'Insert the password';

  @override
  String get signIn => 'Sign In';

  @override
  String get wrongPassword => 'The inserted password is not correct,\ntry again.';

  @override
  String get fillAllFields => 'All fields are mandatory,\ntry again.';

  @override
  String get reservedArea => 'Reserved Area';

  @override
  String get authorizedPeople => 'Solely people authorized by Trisimple are allowed in';

  @override
  String get emailLabel => 'For more information, email:';

  @override
  String get codeInsertLabel => 'Insert the CODE printed on the bracelet\'s Chip';

  @override
  String get condeInsertHint => 'Insert the code';

  @override
  String get approachNfc => 'May approach.';

  @override
  String get unavailableNfc => 'NFC UNAVAILABLE';

  @override
  String get valid => 'VALID';

  @override
  String get invalid => 'INVALID';

  @override
  String get ticket => 'Ticket';

  @override
  String get bracelet => 'Bracelet';

  @override
  String get error => 'Error';
}
