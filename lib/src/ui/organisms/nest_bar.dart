import 'package:flutter/material.dart';
import 'package:psito_games_ui/psito_games_ui.dart';

import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n.dart';
import '../../game/game_controller.dart';
import '../../game/scores.dart';
import '../../version.dart';
import 'victory_panel.dart';

/// What Psito Nest says about itself.
GameInfo nestInfo(AppLocalizations l10n) => GameInfo(
  title: l10n.appTitle,
  version: appVersion,
  howToPlay: l10n.howToPlayBody,
  about: l10n.aboutBody,
  legal: l10n.aboutLegal,
  site: 'https://francisceioseph.github.io/psito-nest/',
);

/// The bar of the nest: the points, the record and the undo.
class NestBar extends StatelessWidget {
  const NestBar({super.key, required this.game});

  final GameController game;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GameBar(
      info: nestInfo(l10n),
      onNewGame: game.newGame,
      onBestGames: () => showBestGames(
        context,
        FutureBuilder<List<Score>>(
          future: const ScoreStore().load(),
          builder: (context, snapshot) =>
              NestScoreTable(scores: snapshot.data ?? const []),
        ),
      ),
      stats: (space) => StatsPill(
        children: [
          StatTile(label: l10n.statScore, value: '${game.state.score}'),
          StatTile(label: l10n.statBest, value: '${game.best}'),
        ],
      ),
      actions: (space) => [
        BarButton(
          tooltip: '${context.gamesUi.undo}  (Ctrl+Z)',
          icon: Icons.undo_rounded,
          onPressed: game.canUndo ? game.undo : null,
        ),
      ],
    );
  }
}
