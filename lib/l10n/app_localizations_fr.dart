// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Psito Nest';

  @override
  String get youWon => 'La reine est éclose !';

  @override
  String get nestFull => 'Le nid est plein !';

  @override
  String winSummary(String points, String bird) {
    return '$points, jusqu’à : $bird';
  }

  @override
  String get statScore => 'Points';

  @override
  String get statBest => 'Record';

  @override
  String get howToPlayBody =>
      'Faites tout glisser avec les flèches du clavier, ou en tirant sur le nid. Deux voisins identiques s’unissent en l’étape suivante de la chaîne : les œufs éclosent, les poussins grandissent et des calopsittes de plus en plus rares apparaissent.\n\nUn nouvel œuf est pondu après chaque glissement. La partie se termine quand la reine dorée éclot, ou quand le nid est plein sans plus rien à unir.\n\nChaque union rapporte des points, d’autant plus que l’oiseau est rare. L’album sous le nid garde tous les oiseaux que vous avez élevés.\n\nCtrl+Z annule le dernier glissement et Ctrl+N lance une nouvelle partie.';

  @override
  String get howToPlayTouch =>
      'Glissez le doigt sur le nid pour tout faire glisser. Deux voisins identiques s’unissent en l’étape suivante de la chaîne : les œufs éclosent, les poussins grandissent et des calopsittes de plus en plus rares apparaissent.\n\nUn nouvel œuf est pondu après chaque glissement. La partie se termine quand la reine dorée éclot, ou quand le nid est plein sans plus rien à unir.\n\nChaque union rapporte des points, d’autant plus que l’oiseau est rare. L’album sous le nid garde tous les oiseaux que vous avez élevés.\n\nLa flèche de la barre annule le dernier glissement.';

  @override
  String get aboutBody =>
      'Assemblez les œufs et élevez des calopsittes rares. Sans publicité, sans télémétrie et sans compte.';

  @override
  String get aboutLegal =>
      'Code sous licence Apache 2.0. Illustrations sous CC0.';

  @override
  String points(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points',
      one: '1 point',
      zero: '0 point',
    );
    return '$_temp0';
  }

  @override
  String nestDescription(String bird, int free) {
    String _temp0 = intl.Intl.pluralLogic(
      free,
      locale: localeName,
      other: '$free places libres',
      one: '1 place libre',
      zero: 'Aucune place libre',
    );
    return 'Nid. Oiseau le plus rare : $bird. $_temp0';
  }

  @override
  String get birdUnknown => 'Pas encore élevé';

  @override
  String get bird1 => 'Œuf';

  @override
  String get bird2 => 'Œuf qui éclot';

  @override
  String get bird3 => 'Nouveau-né';

  @override
  String get bird4 => 'Poussin';

  @override
  String get bird5 => 'Jeune';

  @override
  String get bird6 => 'Gris';

  @override
  String get bird7 => 'Perlé';

  @override
  String get bird8 => 'Cannelle';

  @override
  String get bird9 => 'Lutino';

  @override
  String get bird10 => 'Panaché';

  @override
  String get bird11 => 'Reine dorée';
}
