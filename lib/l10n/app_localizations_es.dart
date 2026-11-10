// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Psito Nest';

  @override
  String get youWon => '¡Nació la reina!';

  @override
  String get nestFull => '¡El nido está lleno!';

  @override
  String winSummary(String points, String bird) {
    return '$points, hasta: $bird';
  }

  @override
  String get statScore => 'Puntos';

  @override
  String get statBest => 'Récord';

  @override
  String get howToPlayBody =>
      'Desliza todo con las flechas del teclado o arrastrando sobre el nido. Dos vecinos iguales se unen en el siguiente paso de la cadena: los huevos eclosionan, los polluelos crecen y aparecen cacatúas ninfa cada vez más raras.\n\nDespués de cada deslizamiento se pone un huevo nuevo. La partida termina cuando nace la reina dorada, o cuando el nido se llena y ya no queda nada que unir.\n\nCada unión da puntos, más cuanto más rara es el ave. El álbum bajo el nido guarda todas las aves que has criado.\n\nCtrl+Z deshace el último deslizamiento y Ctrl+N empieza una partida nueva.';

  @override
  String get aboutBody =>
      'Junta los huevos y cría cacatúas ninfa raras. Sin anuncios, sin telemetría y sin cuenta.';

  @override
  String get aboutLegal => 'Código bajo la licencia Apache 2.0. Arte bajo CC0.';

  @override
  String points(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos',
      one: '1 punto',
      zero: '0 puntos',
    );
    return '$_temp0';
  }

  @override
  String nestDescription(String bird, int free) {
    String _temp0 = intl.Intl.pluralLogic(
      free,
      locale: localeName,
      other: '$free lugares libres',
      one: '1 lugar libre',
      zero: 'Sin lugares libres',
    );
    return 'Nido. Ave más rara: $bird. $_temp0';
  }

  @override
  String get birdUnknown => 'Aún no criada';

  @override
  String get bird1 => 'Huevo';

  @override
  String get bird2 => 'Huevo eclosionando';

  @override
  String get bird3 => 'Recién nacido';

  @override
  String get bird4 => 'Polluelo';

  @override
  String get bird5 => 'Volantón';

  @override
  String get bird6 => 'Gris';

  @override
  String get bird7 => 'Perlada';

  @override
  String get bird8 => 'Canela';

  @override
  String get bird9 => 'Lutino';

  @override
  String get bird10 => 'Arlequín';

  @override
  String get bird11 => 'Reina dorada';
}
