import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:psito_games_ui/psito_games_ui.dart';

import 'game_state.dart';

/// A game in progress, and what the player has reached so far.
class GameController extends ChangeNotifier {
  GameController({int? number, SoundBoard? sounds})
    : number = number ?? _randomNumber(),
      sounds = sounds ?? GameSounds.shared {
    _random = Random(this.number);
    state = GameState.start(_random);
    unlocked = state.highest;
  }

  static int _randomNumber() => Random().nextInt(999999) + 1;

  /// Where the sounds of the nest go.
  final SoundBoard sounds;

  /// The last step that still cracks a shell: the newborn.
  static const lastHatch = 3;

  /// As long as the birds take to slide, so that they join when they meet.
  static const _slide = Duration(milliseconds: 120);

  int number;
  late Random _random;
  late GameState state;

  /// Changes with each new game, so that nothing carries over to the next.
  int gameId = 0;

  /// The best score ever made.
  int best = 0;

  /// The rarest bird ever raised, which opens the album up to it.
  late int unlocked;

  GameState? _previous;

  bool get canUndo => _previous != null;

  void newGame() {
    number = _randomNumber();
    _random = Random(number);
    state = GameState.start(_random);
    _previous = null;
    gameId++;
    notifyListeners();
  }

  /// Puts back what the saved games have reached.
  void restoreProgress({required int best, required int unlocked}) {
    this.best = max(this.best, best);
    this.unlocked = max(this.unlocked, unlocked);
    notifyListeners();
  }

  /// Slides the nest. Only the last slide can be undone.
  void slide(Direction direction) {
    if (state.isOver) return;
    final moved = state.slide(direction);
    if (moved == null) return;
    _previous = state.withoutGhosts;
    state = moved.spawn(_random);
    best = max(best, state.score);
    _sound(moved.ghosts);
    unlocked = max(unlocked, state.highest);
    notifyListeners();
  }

  /// The sounds of a slide that joined [joined]: a shell cracking, two birds
  /// joining, a bird never seen before, and the end of the game.
  void _sound(List<Tile> joined) {
    if (joined.isNotEmpty) {
      final made = joined.map((tile) => tile.level + 1).reduce(max);
      // A bird never raised before calls out.
      if (made > lastHatch && made > unlocked) {
        sounds.play(GameSound.chirp, delay: _slide);
      } else {
        sounds.play(
          made <= lastHatch ? GameSound.hatch : GameSound.join,
          delay: _slide,
        );
      }
    }
    if (state.isWon) {
      sounds.play(GameSound.victory, delay: _slide * 3);
    } else if (state.isStuck) {
      sounds.play(GameSound.refuse, delay: _slide * 2);
    }
  }

  void undo() {
    final previous = _previous;
    if (previous == null || state.isOver) return;
    state = previous;
    _previous = null;
    notifyListeners();
  }
}
