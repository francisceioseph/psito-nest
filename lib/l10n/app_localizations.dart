import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Psito Nest'**
  String get appTitle;

  /// No description provided for @youWon.
  ///
  /// In en, this message translates to:
  /// **'The queen has hatched!'**
  String get youWon;

  /// No description provided for @nestFull.
  ///
  /// In en, this message translates to:
  /// **'The nest is full!'**
  String get nestFull;

  /// No description provided for @winSummary.
  ///
  /// In en, this message translates to:
  /// **'{points}, up to: {bird}'**
  String winSummary(String points, String bird);

  /// No description provided for @statScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get statScore;

  /// No description provided for @statBest.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get statBest;

  /// No description provided for @howToPlayBody.
  ///
  /// In en, this message translates to:
  /// **'Slide everything with the arrow keys, or by dragging across the nest. Two equal neighbours join into the next step of the chain: eggs hatch, chicks grow and rarer and rarer cockatiels appear.\n\nA new egg is laid after each slide. The game ends when the golden queen hatches, or when the nest fills up with nothing left to join.\n\nEvery join gives points, more for rarer birds. The album under the nest keeps every bird you have ever raised.\n\nCtrl+Z undoes the last slide and Ctrl+N starts a new game.'**
  String get howToPlayBody;

  /// How to play on a phone or a tablet, where there is no keyboard.
  ///
  /// In en, this message translates to:
  /// **'Swipe across the nest to slide everything. Two equal neighbours join into the next step of the chain: eggs hatch, chicks grow and rarer and rarer cockatiels appear.\n\nA new egg is laid after each slide. The game ends when the golden queen hatches, or when the nest fills up with nothing left to join.\n\nEvery join gives points, more for rarer birds. The album under the nest keeps every bird you have ever raised.\n\nThe arrow on the bar undoes the last slide.'**
  String get howToPlayTouch;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Join the eggs and raise rare cockatiels. No ads, no telemetry and no account.'**
  String get aboutBody;

  /// No description provided for @aboutLegal.
  ///
  /// In en, this message translates to:
  /// **'Code under the Apache 2.0 license. Art under CC0.'**
  String get aboutLegal;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 points} =1{1 point} other{{count} points}}'**
  String points(int count);

  /// No description provided for @nestDescription.
  ///
  /// In en, this message translates to:
  /// **'Nest. Rarest bird: {bird}. {free, plural, =0{No free places} =1{1 free place} other{{free} free places}}'**
  String nestDescription(String bird, int free);

  /// No description provided for @birdUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not raised yet'**
  String get birdUnknown;

  /// No description provided for @bird1.
  ///
  /// In en, this message translates to:
  /// **'Egg'**
  String get bird1;

  /// No description provided for @bird2.
  ///
  /// In en, this message translates to:
  /// **'Hatching egg'**
  String get bird2;

  /// No description provided for @bird3.
  ///
  /// In en, this message translates to:
  /// **'Newborn'**
  String get bird3;

  /// No description provided for @bird4.
  ///
  /// In en, this message translates to:
  /// **'Chick'**
  String get bird4;

  /// No description provided for @bird5.
  ///
  /// In en, this message translates to:
  /// **'Fledgling'**
  String get bird5;

  /// No description provided for @bird6.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get bird6;

  /// No description provided for @bird7.
  ///
  /// In en, this message translates to:
  /// **'Pearl'**
  String get bird7;

  /// No description provided for @bird8.
  ///
  /// In en, this message translates to:
  /// **'Cinnamon'**
  String get bird8;

  /// No description provided for @bird9.
  ///
  /// In en, this message translates to:
  /// **'Lutino'**
  String get bird9;

  /// No description provided for @bird10.
  ///
  /// In en, this message translates to:
  /// **'Pied'**
  String get bird10;

  /// No description provided for @bird11.
  ///
  /// In en, this message translates to:
  /// **'Golden queen'**
  String get bird11;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
