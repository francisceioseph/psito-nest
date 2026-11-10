// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Psito Nest';

  @override
  String get youWon => 'The queen has hatched!';

  @override
  String get nestFull => 'The nest is full!';

  @override
  String winSummary(String points, String bird) {
    return '$points, up to: $bird';
  }

  @override
  String get statScore => 'Score';

  @override
  String get statBest => 'Best';

  @override
  String get howToPlayBody =>
      'Slide everything with the arrow keys, or by dragging across the nest. Two equal neighbours join into the next step of the chain: eggs hatch, chicks grow and rarer and rarer cockatiels appear.\n\nA new egg is laid after each slide. The game ends when the golden queen hatches, or when the nest fills up with nothing left to join.\n\nEvery join gives points, more for rarer birds. The album under the nest keeps every bird you have ever raised.\n\nCtrl+Z undoes the last slide and Ctrl+N starts a new game.';

  @override
  String get aboutBody =>
      'Join the eggs and raise rare cockatiels. No ads, no telemetry and no account.';

  @override
  String get aboutLegal => 'Code under the Apache 2.0 license. Art under CC0.';

  @override
  String points(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points',
      one: '1 point',
      zero: '0 points',
    );
    return '$_temp0';
  }

  @override
  String nestDescription(String bird, int free) {
    String _temp0 = intl.Intl.pluralLogic(
      free,
      locale: localeName,
      other: '$free free places',
      one: '1 free place',
      zero: 'No free places',
    );
    return 'Nest. Rarest bird: $bird. $_temp0';
  }

  @override
  String get birdUnknown => 'Not raised yet';

  @override
  String get bird1 => 'Egg';

  @override
  String get bird2 => 'Hatching egg';

  @override
  String get bird3 => 'Newborn';

  @override
  String get bird4 => 'Chick';

  @override
  String get bird5 => 'Fledgling';

  @override
  String get bird6 => 'Grey';

  @override
  String get bird7 => 'Pearl';

  @override
  String get bird8 => 'Cinnamon';

  @override
  String get bird9 => 'Lutino';

  @override
  String get bird10 => 'Pied';

  @override
  String get bird11 => 'Golden queen';
}
