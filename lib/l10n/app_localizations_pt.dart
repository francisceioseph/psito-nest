// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Psito Nest';

  @override
  String get youWon => 'A rainha nasceu!';

  @override
  String get nestFull => 'O ninho encheu!';

  @override
  String winSummary(String points, String bird) {
    return '$points, até: $bird';
  }

  @override
  String get statScore => 'Pontos';

  @override
  String get statBest => 'Recorde';

  @override
  String get howToPlayBody =>
      'Deslize tudo com as setas do teclado, ou arrastando no ninho. Dois vizinhos iguais se juntam no próximo passo da corrente: os ovos chocam, os filhotes crescem e aparecem calopsitas cada vez mais raras.\n\nUm ovo novo aparece depois de cada jogada. O jogo termina quando a rainha dourada nasce, ou quando o ninho enche sem nada para juntar.\n\nCada junção dá pontos, e mais para aves mais raras. O álbum embaixo do ninho guarda todas as aves que você já criou.\n\nCtrl+Z desfaz a última jogada e Ctrl+N começa um novo jogo.';

  @override
  String get howToPlayTouch =>
      'Deslize o dedo no ninho para mover tudo. Dois vizinhos iguais se juntam no próximo passo da corrente: os ovos chocam, os filhotes crescem e aparecem calopsitas cada vez mais raras.\n\nUm ovo novo aparece depois de cada jogada. O jogo termina quando a rainha dourada nasce, ou quando o ninho enche sem nada para juntar.\n\nCada junção dá pontos, e mais para aves mais raras. O álbum embaixo do ninho guarda todas as aves que você já criou.\n\nA seta da barra desfaz a última jogada.';

  @override
  String get aboutBody =>
      'Junte os ovos e crie calopsitas raras. Sem anúncios, sem telemetria e sem conta.';

  @override
  String get aboutLegal => 'Código sob a licença Apache 2.0. Arte sob CC0.';

  @override
  String points(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos',
      one: '1 ponto',
      zero: '0 pontos',
    );
    return '$_temp0';
  }

  @override
  String nestDescription(String bird, int free) {
    String _temp0 = intl.Intl.pluralLogic(
      free,
      locale: localeName,
      other: '$free lugares livres',
      one: '1 lugar livre',
      zero: 'Nenhum lugar livre',
    );
    return 'Ninho. Ave mais rara: $bird. $_temp0';
  }

  @override
  String get birdUnknown => 'Ainda não criada';

  @override
  String get bird1 => 'Ovo';

  @override
  String get bird2 => 'Ovo trincando';

  @override
  String get bird3 => 'Recém-nascido';

  @override
  String get bird4 => 'Filhote';

  @override
  String get bird5 => 'Jovem';

  @override
  String get bird6 => 'Cinza';

  @override
  String get bird7 => 'Pérola';

  @override
  String get bird8 => 'Canela';

  @override
  String get bird9 => 'Lutino';

  @override
  String get bird10 => 'Arlequim';

  @override
  String get bird11 => 'Rainha dourada';
}
