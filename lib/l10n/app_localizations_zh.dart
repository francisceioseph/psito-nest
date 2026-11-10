// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Psito Nest';

  @override
  String get youWon => '女王孵出来了！';

  @override
  String get nestFull => '鸟巢满了！';

  @override
  String winSummary(String points, String bird) {
    return '$points，最高：$bird';
  }

  @override
  String get statScore => '得分';

  @override
  String get statBest => '最高';

  @override
  String get howToPlayBody =>
      '用方向键或在鸟巢上拖动来移动所有的格子。两个相同的相邻格子会合成链条中的下一阶段：蛋会孵化，雏鸟会长大，还会出现越来越稀有的玄凤鹦鹉。\n\n每次移动后会生下一个新蛋。当金色女王孵出，或者鸟巢满了再也无法合成时，游戏结束。\n\n每次合成都会得分，鸟越稀有分数越高。鸟巢下面的图鉴会记下你养过的每一种鸟。\n\nCtrl+Z 撤销上一步移动，Ctrl+N 开始新游戏。';

  @override
  String get aboutBody => '合并鸟蛋，养出稀有的玄凤鹦鹉。没有广告，没有遥测，也不需要账号。';

  @override
  String get aboutLegal => '代码采用 Apache 2.0 许可证。美术采用 CC0。';

  @override
  String points(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分',
    );
    return '$_temp0';
  }

  @override
  String nestDescription(String bird, int free) {
    String _temp0 = intl.Intl.pluralLogic(
      free,
      locale: localeName,
      other: '还有 $free 个空位',
      zero: '没有空位',
    );
    return '鸟巢。最稀有的鸟：$bird。$_temp0';
  }

  @override
  String get birdUnknown => '尚未养成';

  @override
  String get bird1 => '蛋';

  @override
  String get bird2 => '破壳的蛋';

  @override
  String get bird3 => '刚出生';

  @override
  String get bird4 => '雏鸟';

  @override
  String get bird5 => '幼鸟';

  @override
  String get bird6 => '灰色';

  @override
  String get bird7 => '珍珠';

  @override
  String get bird8 => '肉桂';

  @override
  String get bird9 => '黄化';

  @override
  String get bird10 => '花斑';

  @override
  String get bird11 => '金色女王';
}
