import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../game/game_state.dart';

String birdArt(int level) => 'assets/birds/$level.png';

/// Every bird of the chain, to load them before the first game.
Iterable<String> allBirdArt() => [
  for (var level = 1; level <= maxLevel; level++) birdArt(level),
];

String birdName(AppLocalizations l10n, int level) => switch (level) {
  1 => l10n.bird1,
  2 => l10n.bird2,
  3 => l10n.bird3,
  4 => l10n.bird4,
  5 => l10n.bird5,
  6 => l10n.bird6,
  7 => l10n.bird7,
  8 => l10n.bird8,
  9 => l10n.bird9,
  10 => l10n.bird10,
  _ => l10n.bird11,
};

/// The drawing of one bird of the chain, from the egg to the queen.
class BirdArt extends StatelessWidget {
  const BirdArt(this.level, {super.key});

  final int level;

  @override
  Widget build(BuildContext context) => Image.asset(
    birdArt(level),
    fit: BoxFit.fill,
    filterQuality: FilterQuality.medium,
    gaplessPlayback: true,
  );
}
