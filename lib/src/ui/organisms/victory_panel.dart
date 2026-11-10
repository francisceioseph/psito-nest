import 'package:flutter/material.dart';
import 'package:psito_games_ui/psito_games_ui.dart';

import '../../../l10n/l10n.dart';
import '../../game/game_controller.dart';
import '../../game/scores.dart';
import '../atoms/bird_art.dart';

/// The best games: the points and the biggest bird raised.
class NestScoreTable extends StatelessWidget {
  const NestScoreTable({super.key, required this.scores, this.highlight});

  final List<Score> scores;
  final Score? highlight;

  @override
  Widget build(BuildContext context) => ScoreTable<Score>(
    scores: scores,
    highlight: highlight,
    name: (score) => score.name,
    details: (score) => [
      Text(context.l10n.points(score.points)),
      const SizedBox(width: 10),
      ExcludeSemantics(child: Image.asset(birdArt(score.level), width: 26)),
    ],
  );
}

/// Asks for the player's name at the end of a game and shows where it
/// landed.
class VictoryPanel extends StatelessWidget {
  const VictoryPanel({super.key, required this.game, required this.store});

  final GameController game;
  final ScoreStore store;

  Future<Widget> _save(String name) async {
    final mine = Score(
      name: name,
      points: game.state.score,
      level: game.state.highest,
      game: game.number,
    );
    final scores = insertScore(await store.load(), mine);
    await store.save(scores);
    await store.saveName(name);
    return NestScoreTable(scores: scores, highlight: mine);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = game.state;
    return VictoryCard(
      title: state.isWon ? l10n.youWon : l10n.nestFull,
      summary: l10n.winSummary(
        l10n.points(state.score),
        birdName(l10n, state.highest),
      ),
      lastName: store.lastName,
      onSave: _save,
      onNewGame: game.newGame,
    );
  }
}
