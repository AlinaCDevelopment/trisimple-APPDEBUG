import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'version'**
  String get version;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again.'**
  String get tryAgain;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error!'**
  String get connectionError;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @pendingRecords.
  ///
  /// In en, this message translates to:
  /// **'Pending Records'**
  String get pendingRecords;

  /// No description provided for @badConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get badConnection;

  /// No description provided for @rightConnection.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get rightConnection;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Plataform'**
  String get platform;

  /// No description provided for @contactsLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact of the technician\nin charge of the event for support:'**
  String get contactsLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Insert the password'**
  String get passwordHint;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'The inserted password is not correct,\ntry again.'**
  String get wrongPassword;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'All fields are mandatory,\ntry again.'**
  String get fillAllFields;

  /// No description provided for @reservedArea.
  ///
  /// In en, this message translates to:
  /// **'Reserved Area'**
  String get reservedArea;

  /// No description provided for @authorizedPeople.
  ///
  /// In en, this message translates to:
  /// **'Solely people authorized by Trisimple are allowed in'**
  String get authorizedPeople;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'For more information, email:'**
  String get emailLabel;

  /// No description provided for @codeInsertLabel.
  ///
  /// In en, this message translates to:
  /// **'Insert the CODE printed on the bracelet\'s Chip'**
  String get codeInsertLabel;

  /// No description provided for @condeInsertHint.
  ///
  /// In en, this message translates to:
  /// **'Insert the code'**
  String get condeInsertHint;

  /// No description provided for @approachNfc.
  ///
  /// In en, this message translates to:
  /// **'May approach.'**
  String get approachNfc;

  /// No description provided for @unavailableNfc.
  ///
  /// In en, this message translates to:
  /// **'NFC UNAVAILABLE'**
  String get unavailableNfc;

  /// No description provided for @unsupportedTag.
  ///
  /// In en, this message translates to:
  /// **'The tag read is not supported!'**
  String get unsupportedTag;

  /// No description provided for @tagLost.
  ///
  /// In en, this message translates to:
  /// **'Tag was lost. \nKeep the bracelet close until results are shown.'**
  String get tagLost;

  /// No description provided for @platformError.
  ///
  /// In en, this message translates to:
  /// **'A platform error occured.'**
  String get platformError;

  /// No description provided for @processError.
  ///
  /// In en, this message translates to:
  /// **'An error occured during the process.'**
  String get processError;

  /// No description provided for @valid.
  ///
  /// In en, this message translates to:
  /// **'VALID'**
  String get valid;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'INVALID'**
  String get invalid;

  /// No description provided for @ticket.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get ticket;

  /// No description provided for @bracelet.
  ///
  /// In en, this message translates to:
  /// **'Bracelet'**
  String get bracelet;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
