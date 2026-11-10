// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Psito Nest';

  @override
  String get youWon => 'Die Königin ist geschlüpft!';

  @override
  String get nestFull => 'Das Nest ist voll!';

  @override
  String winSummary(String points, String bird) {
    return '$points, bis: $bird';
  }

  @override
  String get statScore => 'Punkte';

  @override
  String get statBest => 'Rekord';

  @override
  String get howToPlayBody =>
      'Schiebe alles mit den Pfeiltasten oder durch Ziehen über das Nest. Zwei gleiche Nachbarn vereinen sich zur nächsten Stufe der Kette: Eier schlüpfen, Küken wachsen, und immer seltenere Nymphensittiche erscheinen.\n\nNach jedem Schieben wird ein neues Ei gelegt. Das Spiel endet, wenn die goldene Königin schlüpft oder wenn das Nest voll ist und sich nichts mehr vereinen lässt.\n\nJede Vereinigung bringt Punkte, mehr für seltenere Vögel. Das Album unter dem Nest bewahrt jeden Vogel, den du je aufgezogen hast.\n\nStrg+Z nimmt das letzte Schieben zurück, und Strg+N startet ein neues Spiel.';

  @override
  String get aboutBody =>
      'Füge die Eier zusammen und ziehe seltene Nymphensittiche auf. Ohne Werbung, ohne Telemetrie und ohne Konto.';

  @override
  String get aboutLegal =>
      'Code unter der Apache-2.0-Lizenz. Grafiken unter CC0.';

  @override
  String points(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Punkte',
      one: '1 Punkt',
      zero: '0 Punkte',
    );
    return '$_temp0';
  }

  @override
  String nestDescription(String bird, int free) {
    String _temp0 = intl.Intl.pluralLogic(
      free,
      locale: localeName,
      other: '$free freie Plätze',
      one: '1 freier Platz',
      zero: 'Keine freien Plätze',
    );
    return 'Nest. Seltenster Vogel: $bird. $_temp0';
  }

  @override
  String get birdUnknown => 'Noch nicht aufgezogen';

  @override
  String get bird1 => 'Ei';

  @override
  String get bird2 => 'Schlüpfendes Ei';

  @override
  String get bird3 => 'Frisch geschlüpft';

  @override
  String get bird4 => 'Küken';

  @override
  String get bird5 => 'Jungvogel';

  @override
  String get bird6 => 'Grau';

  @override
  String get bird7 => 'Perl';

  @override
  String get bird8 => 'Zimt';

  @override
  String get bird9 => 'Lutino';

  @override
  String get bird10 => 'Schecke';

  @override
  String get bird11 => 'Goldene Königin';
}
