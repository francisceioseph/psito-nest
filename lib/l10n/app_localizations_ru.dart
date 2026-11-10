// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Psito Nest';

  @override
  String get youWon => 'Королева вылупилась!';

  @override
  String get nestFull => 'Гнездо заполнено!';

  @override
  String winSummary(String points, String bird) {
    return '$points, лучшая птица: $bird';
  }

  @override
  String get statScore => 'Очки';

  @override
  String get statBest => 'Рекорд';

  @override
  String get howToPlayBody =>
      'Сдвигайте всё стрелками на клавиатуре или проводя по гнезду. Две одинаковые соседние клетки объединяются в следующую ступень цепочки: яйца проклёвываются, птенцы растут, и появляются всё более редкие кореллы.\n\nПосле каждого сдвига появляется новое яйцо. Игра заканчивается, когда вылупляется золотая королева или когда гнездо заполнено и объединять больше нечего.\n\nКаждое объединение приносит очки, и тем больше, чем реже птица. Альбом под гнездом хранит всех птиц, которых вы когда-либо вырастили.\n\nCtrl+Z отменяет последний сдвиг, а Ctrl+N начинает новую игру.';

  @override
  String get howToPlayTouch =>
      'Проведите пальцем по гнезду, чтобы сдвинуть всё. Две одинаковые соседние клетки объединяются в следующую ступень цепочки: яйца проклёвываются, птенцы растут, и появляются всё более редкие кореллы.\n\nПосле каждого сдвига появляется новое яйцо. Игра заканчивается, когда вылупляется золотая королева или когда гнездо заполнено и объединять больше нечего.\n\nКаждое объединение приносит очки, и тем больше, чем реже птица. Альбом под гнездом хранит всех птиц, которых вы когда-либо вырастили.\n\nСтрелка на панели отменяет последний сдвиг.';

  @override
  String get aboutBody =>
      'Соединяйте яйца и выращивайте редких корелл. Без рекламы, без телеметрии и без учётной записи.';

  @override
  String get aboutLegal => 'Код под лицензией Apache 2.0. Рисунки под CC0.';

  @override
  String points(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count очков',
      few: '$count очка',
      one: '$count очко',
      zero: '0 очков',
    );
    return '$_temp0';
  }

  @override
  String nestDescription(String bird, int free) {
    String _temp0 = intl.Intl.pluralLogic(
      free,
      locale: localeName,
      other: '$free свободных мест',
      few: '$free свободных места',
      one: '$free свободное место',
      zero: 'Свободных мест нет',
    );
    return 'Гнездо. Самая редкая птица: $bird. $_temp0';
  }

  @override
  String get birdUnknown => 'Ещё не выращена';

  @override
  String get bird1 => 'Яйцо';

  @override
  String get bird2 => 'Проклёвывающееся яйцо';

  @override
  String get bird3 => 'Новорождённый';

  @override
  String get bird4 => 'Птенец';

  @override
  String get bird5 => 'Слёток';

  @override
  String get bird6 => 'Серая';

  @override
  String get bird7 => 'Жемчужная';

  @override
  String get bird8 => 'Коричная';

  @override
  String get bird9 => 'Лютино';

  @override
  String get bird10 => 'Пегая';

  @override
  String get bird11 => 'Золотая королева';
}
